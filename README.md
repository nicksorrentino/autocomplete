Autocomplete
============

CoffeeScript jQuery Autocomplete, without jQuery UI dependence

API calls expect the open search format ["query", ["sug1", "sug2", "sug3"]]

Options
-------
* url = API call to get the data (Default: "/autocomplete")
* form = jQuery object of the form that should be submitted when an suggestion is clicked (Defaults to the inputs parent form)

Coming Soon
-----------
* Options to pass data instead of url
* Callback function to allow for custom response types and post ajax call handling
