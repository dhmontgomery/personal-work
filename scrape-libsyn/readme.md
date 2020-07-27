# scrape_libsyn()

I host my podcast on Libsyn, a great hosting service that provides very useful stats on episode downloads. Unfortunately, Libsyn doesn't offer an easy way to download this data in the format I want: a spreadsheet with data on downloads per day for each episode. (I can automate downloads of any one particular episode's downloads per day, but can't get all of them at once.)

So I wrote a function in R that will take your Libsyn login info and automatically download this for you. 

`scrape_libsyn()` requires four inputs:

- `show_id`` is a unique ID number for your show that can be tricky to get. I found mine by visiting the Stats page, viewing the source code, and searching for "filterId"
- `state_date` is the first day of stats you want to pull — probably your Episode 1 release date. This should be in format "YYYY-MM-DD"
- `username` is the email address you use as your username to log in to Libsyn
- `password` is your password

For example, after loading the function, you might call it like this:

```
scrape_libsyn("123456", start_date = "2019-01-01", username = "myemail@domain.com", password = "password1234")
```

It will produce three outputs, two in your R environment and one on your desktop:

- `overall-data` will be a dataframe with columns `item_id`, `title`, `released` (for release date), `downloads`, `mergename` (a cleaned up full title), and `url` (the URL where that episode's stats live), and one row per episode
- `episode_data` will be a dataframe with columns `date` (for date of download), `downloads` (the number of downloads that day), `title` (the title of the episode in question), `released` (the episode's release date), `days` (number of days between the download date and the episode's release date), and `cumulative_dl` (the cumulative downloads of a given episode up to that date). It will have one row per episode per day
- A file in your current working directory, with `episode_data` saved to CSV format as `episode_data_YYYY-MM-DD.csv`, with today's date in the filename. 

Please run this responsibly and not overwhelm Libsyn's servers, or they might block this. 

Load the script into R by running the following:

`source("https://raw.githubusercontent.com/dhmontgomery/personal-work/master/scrape-libsyn/scrape_libsyn.R")`

Written by David H. Montgomery, released under MIT License.
