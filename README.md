# My Application

## Overview

This application allows users to register, log in, and create microposts. Users can also post photos, search for other users, and update their account settings.

## Features

- **User Registration**: Users can register for an account. After registration, they will receive an activation email.
- **Email Activation**: Users must click the link in their activation email to log in to their profile page.
- **Microposts**: Once logged in, users can navigate to the home page to create a micropost. They can also post photos.
- **User Search**: A search bar is available for users to search for other users.
- **Account Settings**: Under the account settings, users can change their email and password.

## Getting Started

To get started with the app, clone the repo and then install the needed gems:
$ bundle install --without production


Next, migrate the database:
$ rails db:migrate


Finally, run the test suite to verify that everything is working correctly:
$ rails test


If the test suite passes, you'll be ready to run the app in a local server:
$ rails server


## Contributing

Bug reports and pull requests are welcome on GitHub at [\[repository link\]](https://github.com/tchering/sonam_app). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The application is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).