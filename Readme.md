### Current Features
1. Add Book
2. Add Comment
3. Add Note
4. Make Genre Favourite
5. Make Book Favourite
6. SignIn using phone number(custom API implementation)
7. Book List Page
8. Book Detail Page
9. Genre List Page

### Database Implementation
##### Genre Table
|sn|epoc|genreid|genre|
|-|-|-|-|
##### Book Table
|sn|epoc|genreid|bookid|name|description|userid
|-|-|-|-|-|-|-|
##### Comment Table
|sn|epoc|commentid|userid|bookid|comment
|-|-|-|-|-|-|
##### Note Table
|sn|epoc|noteid|userid|bookid|note
|-|-|-|-|-|-|
##### Favourite Genre Table
|sn|epoc|genreid|genre|isfav
|-|-|-|-|-|
##### Favourite Book Table
|sn|epoc|genreid|userid|bookid|isfav
|-|-|-|-|-|-|

### Remaining Feature
1. Search Book/Genre
2. Book detail comment/notes UI adjustment
3. Root widget routing mechanism
4. small fixes on login(for now it may case some issue while login)
4. UI improvement
5. Image upload
6. Code optimization

### Screenshots

![Screenshot_20210607-130359](https://user-images.githubusercontent.com/10628287/120978024-a8234080-c791-11eb-8224-2a93bb8eac16.jpg)
![Screenshot_20210607-130419](https://user-images.githubusercontent.com/10628287/120978036-ac4f5e00-c791-11eb-8cc2-7272b471f385.jpg)
![Screenshot_20210607-130500](https://user-images.githubusercontent.com/10628287/120978040-ae192180-c791-11eb-82ca-2572e67d1aaf.jpg)
![Screenshot_20210607-130506](https://user-images.githubusercontent.com/10628287/120978046-aeb1b800-c791-11eb-9255-202973bbc057.jpg)
![Screenshot_20210607-130519](https://user-images.githubusercontent.com/10628287/120978050-afe2e500-c791-11eb-99fd-b8f12daa59a8.jpg)
![Screenshot_20210607-130840](https://user-images.githubusercontent.com/10628287/120978115-c2f5b500-c791-11eb-87d7-e679fbcd6650.jpg)
![Screenshot_20210607-130845](https://user-images.githubusercontent.com/10628287/120978125-c5f0a580-c791-11eb-8b77-3d4a2bbbe6f2.jpg)
![Screenshot_20210607-130858](https://user-images.githubusercontent.com/10628287/120978131-c721d280-c791-11eb-9cde-d6824c6dc0a8.jpg)
