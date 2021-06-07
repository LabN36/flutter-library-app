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
