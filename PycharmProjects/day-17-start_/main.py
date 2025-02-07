class User:

    def __init__(self, user_id, username):
        print("new user being created...")
        self.id = user_id
        self.username = username
        self.followers = 0 # Not all attributes need to have a parameter
        self.following = 0

    def follow(self, user):   #Method - Function in attached to a class
        user.followers += 1
        self.following += 1

# creating users using existing attributes

user_1 = User("001","Oke")
user_2 = User("002","Jack")

user_1.follow(user_2)

# user_1 = User()  #object of User class created
# user_1.id = "001" #attribute id added to object user_1
# user_1.username = "oke" #attribute username is added to object user_id

print(f"{user_1.username},{user_1.id}")
print(user_1.followers)
print(user_1.following)


#constructor - part of blueprint that allow us to specify what should happen when object is being constructed
#Also known as initializing attributes in an object
#Create a constructor by using the init key word def __init__(self):