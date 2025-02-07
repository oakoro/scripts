# file = open("my_file.txt")
# content = file.read()
# print(content)
# file.close()
#
#other option to above
with open("./test/my_file.txt") as file:
    content1 = file.read()
    print(content1)

#To write into a file -- a = append, w = write
# with open("my_file.txt",mode="a") as file:
#     file.write("\n Eti melo New text")