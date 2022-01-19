from cs50 import get_float


def main():
    changeOwed = getFloat()
    coinsNumber = 0
    cents = round(changeOwed * 100)
    # If we still have more than 25 cents
    while cents > 0:
        if cents >= 25:
            cents -= 25
            coinsNumber += 1
        # If we still have more than 10 cents
        elif cents >= 10:
            cents -= 10
            coinsNumber += 1
        elif cents >= 5:
            cents -= 5
            coinsNumber += 1
        elif cents > 0:
            cents -= 1
            coinsNumber += 1
    print(coinsNumber)


# Prompt user for positive integer
def getFloat():
    while True:
        n = get_float("Change owed: ")
        if n > 0:
            break
    return n


main()