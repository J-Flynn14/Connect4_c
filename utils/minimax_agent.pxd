cimport numpy as np

cdef class MinimaxAgent:
    cdef double evaluate_window(self, list window, int player)
    cdef double get_score(self, np.ndarray board, int player)
    cpdef tuple minimax(self, np.ndarray board, int depth, int maximising_player, double alpha, double beta)