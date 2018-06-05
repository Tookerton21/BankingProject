# BankingProject
6/4/18
Added WireTransfer to UI:
	Transfers money from one users checking account to another users account.
	Ensures that the user that is sending funds has sufficient funds, and if
	not then nothing happens

Added TranStoC to UI:
	Transfers money from a users savings to their checking account. Ensures that
	the user has sufficient funds in their savings before doing such a transaction.

5/31/18
I started cleaning up the project, and added two new deliverables of 
moding the checking and savings to a value since the last push.

functionality:
- add a user to database
- remove a user from database
- set checking and savings
- print function for testing/debugging 

The next step is figuring out how to extract the current balance from both
checking and savings. This way we can do the simple arithmetic to add and 
subtract from the current balance.

Known Bugs:
- Have not figured out how to be able to use decimals. It lets you make the
  modification to the database, but when I call the printUser functions I
  get an Error. 
