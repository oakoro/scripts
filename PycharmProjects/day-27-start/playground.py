def add(*args):
    sum = 0
    for n in args:
        sum += n
    return sum

def calculate(n,**kwargs):
    print(kwargs)
    n += kwargs["add"]
    n *= kwargs["multiply"]
    print(n)




print(add(34,3,5,2))

print(calculate(2, add=3, multiply = 5))

#write own kwargs
class Car:

    def __init__(self, **kwargs):
        # self.make = kwargs["make"]
        # self.model = kwargs["model"]
        #To control runtime error use get
        self.make = kwargs.get("make")
        self.model = kwargs.get("model")
        self.color = kwargs.get("color")

my_car = Car(make="Nissan", model="GT-R")
print(my_car.model)

my_car1 = Car(make="Nissan")
print(my_car1.make)


def all_aboard(a, *args, **kw):
    print(a, args, kw)

all_aboard(4, 7, 3, 0, x=10, y=64)