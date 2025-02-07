#FileNotFound
# with open("a_file.txt") as file:
#     file.read()

# height = float(input("Height"))
# weight = float(input("Weight"))
#
# if height > 3:
#     raise ValueError("Human height should not be over 3 meters")
#
# bmi = weight / height ** 2
# print(bmi)


facebook_posts = [
    {'Likes': 21, 'Comments': 2},
    {'Likes': 13, 'Comments': 2, 'Shares': 1},
    {'Comments': 4, 'Shares': 2},
    {'Likes': 19, 'Comments': 3}

]
def count_like(posts):
    try:
        total_likes = 0
        for post in posts:
            total_likes = total_likes + post['Likes']
        return total_likes
    except:
        print("invalid key")

count_like(facebook_posts)