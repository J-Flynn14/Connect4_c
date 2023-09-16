cimport numpy as np

cpdef int check_win(np.ndarray board)
cpdef list[int] get_valid_locations(np.ndarray board)
cpdef np.ndarray drop_piece(np.ndarray board, int col, int player)