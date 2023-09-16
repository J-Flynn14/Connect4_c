import numpy as np
cimport numpy as np
np.import_array()

cpdef int check_win(np.ndarray board):
    cdef list[np.ndarray] diags_p, diags_n, rows, cols, all_states
    cdef np.ndarray[int, ndim=1] state
    cdef int i

    if np.count_nonzero(board) == board.shape[0]*board.shape[1]: return 3
    diags_p = [np.diagonal(board[::-1, :], i) for i in range(-board.shape[0]+1, board.shape[1])]
    diags_n = [np.diagonal(board, i) for i in range(board.shape[1]-1, -board.shape[0], -1)]

    rows = [row for row in board]
    cols = [board[:, i] for i in range(board.shape[1])]

    all_states = diags_p + diags_n + rows + cols

    for state in all_states:
        for i in range(len(state)):
            try:
                if state[i] == state[i+1] == state[i+2] == state[i+3]:
                    if state[i] == 0: pass
                    elif state[i] == 1: return 1
                    elif state[i] == 2: return 2
            except IndexError:
                pass
    return 0

cpdef list[int] get_valid_locations(np.ndarray board):
    cdef list[int] col_arr = []
    cdef Py_ssize_t i_range = board.shape[1]
    cdef int i

    for i in range(i_range):
        if np.count_nonzero(board[:, i]) != board.shape[0]:
            col_arr.append(i)
    return col_arr

cpdef np.ndarray drop_piece(np.ndarray board, int col, int player):
    cdef np.ndarray[int, ndim=2] b_copy = np.copy(board)
    cdef int row = (board.shape[0] - int(np.count_nonzero(board[:, col]))) - 1

    b_copy[row][col] = player
    return b_copy