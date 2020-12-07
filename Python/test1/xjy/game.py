import random
temp = input('please input number\n')
guess = int(temp)
secret = random.randint(1,30)
while guess != secret:
    temp = input('wrong,please input again\n')
    guess = int(temp)

    if guess > secret:
        print("it's too big")
    else:
        print("it's too small")
if guess != secret:
    print('bingo')
print('end')