def new_line():
    print('.')

def three_lines():
    new_line()
    new_line()
    new_line()

def nine_lines():
    three_lines()
    three_lines()
    three_lines()

def clear_screen():
    nine_lines()
    nine_lines()
    three_lines()
    three_lines()
    new_line()

nine_lines()
print("Calling clear_screen()")
clear_screen()

# Journal

name = "Nick Sagan"
age = 33

def greeting_with(greet):
    result = greet + "! My name is " + name + " and I'm " + str(age) + " years old."
    print(result)

greeting_with("Hello")
greeting_with("Salut")
greeting_with("Hi")
