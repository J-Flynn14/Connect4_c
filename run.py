from utils import get_valid_locations
from utils.env import ConnectFour

if __name__ == '__main__':
    # initialise enviroment
    env = ConnectFour(board_size=(7, 6))

    observation = env.reset()  # reset environment to inital state

    while True:
        env.render()  # render window

        action = env.get_action(observation)  # get action from player or agent

        if action in get_valid_locations(env.board):
            observation = env.step(action)  # apply ation on board