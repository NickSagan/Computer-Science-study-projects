# Abstraction and scope

from cs50 import get_int


def main():
    a = get_positive_int()
    for i in range(a):
        for z in range(a-i-1):
            print(" ", end="")
        for j in range(i+1):
            print("#", end="")
        print()


# Prompt user for positive integer
def get_positive_int():
    while True:
        n = get_int("Height: ")
        if n > 0 and n < 9:
            break
    return n


main()
