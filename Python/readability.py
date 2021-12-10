from cs50 import get_string

text = get_string("Text: ")
wordsNumber = text.count(" ")
sentencesNumber = text.count(".")
sentencesNumber += text.count("!")
sentencesNumber += text.count("?")
letterNumber = 0

for n in text:
    if n.isalpha():
        letterNumber += 1

# Calculating formula
s = sentencesNumber / wordsNumber * 100.00
l = letterNumber / wordsNumber * 100.00
gradeNumber = round(0.0588 * l - 0.296 * s - 15.8)

# Printing the Grade
if gradeNumber < 1:
    print("Before Grade 1")
elif gradeNumber > 16:
    print("Grade 16+")
else:
    print(f"Grade {gradeNumber}")
