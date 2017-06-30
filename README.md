# wine-library
Flatiron school MVC Sinatra Active Record Project

Virtual Wine Cellar

This is a MVC Sinatra application that allows users to create accounts and add information about each bottle in their virtual wine cellar.  The Models included are:

  Owner - has many bottles, and has many wineries through owned bottles
  Bottle - belong to an owner and belongs to a winery
  Winery - has many bottles

At the main index page you may signup for an account, login to an account or view your cellar if logged in.
Bottles contain information on wine type, winery, year and price paid and can be edited by the owner only
Each owner can see all the bottles in the overall bottle universe or in their cellar but can only edit those in their cellar
Each owner can see all the bottle in their cellar of a given wine type or from a given winery
Owners can add, edit or delete any of their bottles

Installation

Pull requests are welcome on Github at https://github.com/curlywallst/wine-library.

Usage

To run the application:

$ shotgun
$ localhost:9393 (or whatever port you use)


Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/curlywallst/wine_library. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the Contributor Covenant code of conduct.


License

This application was developed under the guidance of Flatiron School on loearn.co.
