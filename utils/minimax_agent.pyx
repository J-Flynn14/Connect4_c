from utils import *
import numpy as np
cimport numpy as np
np.import_array()

cdef class MinimaxAgent:
    def __cinit__(self):
        pass

    cdef double evaluate_window(self, list window, int player):
        cdef double score = 0.0
        cdef int opp_player

        if player == 2:
            opp_player = 1
        else:
            opp_player = 2
        
        if window.count(player) == 4:
            score += 100.0
        elif window.count(player) == 3 and window.count(0) == 1:
            score += 5.0
        elif window.count(player) == 2 and window.count(0) == 2:
            score += 2.0
        elif window.count(opp_player) == 3 and window.count(0) == 1:
            score -= 50.0
        return score
    
    cdef double get_score(self, np.ndarray board, int player):
        cdef list[int] center_array, row_array, col_array, window 
        cdef int center_count, r, c
        cdef double score = 0.0
       
        center_array = [int(i) for i in list(board[:, board.shape[1]//2])]
        center_count = center_array.count(player)

        score += center_count * 3

        #add score for rows
        for r in range(board.shape[0]):
            row_array = [int(i) for i in list(board[r, :])]
            for c in range(board.shape[1]-3):
                window = row_array[c:c+4]
                score += self.evaluate_window(window, player)

        #add score for columns
        for c in range(board.shape[1]):
            col_array = [int(i) for i in list(board[:, c])]
            for r in range(board.shape[0]-3):
                window = col_array[r:r+4]
                score += self.evaluate_window(window, player)

        #add score for posative & negative diagonals
        for r in range(board.shape[0]-3):
            for c in range(board.shape[1]-3):
                window = [board[r+i][c+i] for i in range(4)]
                score += self.evaluate_window(window, player)

        for r in range(board.shape[0]-3):
            for c in range(board.shape[1]-3):
                window = [board[r+3-i][c+i] for i in range(4)]
                score += self.evaluate_window(window, player)
        return score
    
    cpdef tuple minimax(self, np.ndarray board, int depth, int maximising_player, double alpha, double beta):
        cdef list[int] valid_locations
        cdef np.ndarray[int, ndim=2] b_copy
        cdef double p_score
        cdef double value
        cdef int player_won, column, col

        if depth == 0: return (-1, self.get_score(board, 2))

        player_won = check_win(board)

        if player_won == 1: return (-1, -10000000000000.0)
        elif player_won == 2: return (-1, 100000000000000.0)
        elif player_won == 3: return (-1, 0.0)

        valid_locations = get_valid_locations(board)

        if maximising_player == 1:
            value = -np.inf
            column = np.random.choice(valid_locations)

            for col in valid_locations:
                b_copy = drop_piece(board, col, 2)
                p_score = self.minimax(b_copy, depth-1, 0, alpha, beta)[1]

                if p_score > value:
                    value = p_score
                    column = col

                alpha = max(alpha, value)

                if alpha >= beta:
                    break

            return (column, value)
        else:
            value = np.inf
            column = np.random.choice(valid_locations)

            for col in valid_locations:
                b_copy = drop_piece(board, col, 1)
                p_score = self.minimax(b_copy, depth-1, 1, alpha, beta)[1]

                if p_score < value:
                    value = p_score
                    column = col

                beta = min(beta, value)

                if alpha >= beta:
                    break

            return (column, value)