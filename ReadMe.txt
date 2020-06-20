ReadMe

For this assignment, we were to clean up a collection of data files, into a single file.
Notes in the file cover largely what my steps were during the process. Here you can find slightly more detal.

There are two main data sets, the train and the test data sets. These were cleaned up seperately, and then merged together.
First, only the relevant columns of the X_train file were selected. The relevant files were selected by looking at the features.txt file. according to the exercise, mean and standard deviations were calculated.
They were then renamed in order to make sure the names are logical. What the names refer to can be found in the codebook.txt
Next I added whether the dataset was train or test with the cbind function, using a character vector.
I then also added the activity which corresponded to each data measurement! These are numbers for now but will be replaced after. This was done with cbind again.

Next I repeated everything for the test dataset.
I then use the rbind the merge the two, with the smaller test dataset underneath the train dataset.
Now that the datasets are combined, I use gsub to find and replace all the activity numbers by their designated description.

Finally, I still added the subject numbers, which is primarily important according to the final part of the assignment. 
I clean the subject numbers up a bit more bu using the sprintf command, so that all numbers are 2 characters.

Finally, we have to make an independent dataset with the averages of all subjects and activities. No distinguishment between test or train needs to be made.
I wrote a small script that first selects a single subject, then a single activity, and then calculates all averages of the remaining data columns.
This data is then stored into  the an empty dataframe that I prepared beforehand. This is repeated for every activity and every subject using a double for loop.
The presented dataframe then has all necessary data. Again, the codebook contains information on what the different columns refer to.


