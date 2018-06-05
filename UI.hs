module UI where
import BuildData

--testDisplayUsers = displayUsers
--testAddUser = addUser "Tochi" "Tran
main :: IO()
main = do
 putStrLn "Menu of HaskeshBank: "
 putStrLn "1: To add User"
 putStrLn "2: Display all Users"
 putStrLn "3: Display checking balance"
 putStrLn "4: Display savings balance"
 putStrLn "5: Remove User"
 putStrLn "6: Wire transfer"
 putStrLn "7: Transfer to saving to checking"
 putStrLn "8: Exit"
 option <- readLn :: IO Int
 case option of
  1 -> addUserUI >> main
  2 -> displayUsers >> main
  3 -> checkingAmnt >> main
  4 -> savingsAmnt >> main
  5 -> removeUserUI >> main
  6 -> tranMoney >> main
  7 -> tranStoC >> main
  8 -> return()

tranStoC = do
  putStrLn "Enter User Id"
  userId <- readLn :: IO Int

  putStrLn "Amount to transfer to Checking"
  amnt <- readLn :: IO Double

  cBalance1 <- getSavings userId
  cBalance2 <- getChecking userId
  let nBalance1 = cBalance1 - amnt
  let nBalance2 = cBalance2 + amnt

  if nBalance1 > 0
    then do
      modSavings userId nBalance1
      modChecking userId nBalance2
      putStrLn "Transfer complete"
    else
      putStrLn "Insuffienct Funds"

tranMoney = do
  putStrLn "From Id Num: "
  userIdF <- readLn :: IO Int

  putStrLn "To Id Num: "
  userIdT <- readLn :: IO Int

  putStrLn "Amount to transfer: "
  amnt <- readLn :: IO Double

  cBalance1 <- getChecking userIdF -- balance from sending account
  cBalance2 <- getChecking userIdT -- balance for receiving account
  let nBalance1 = cBalance1 - amnt  -- new balance from sending account
  let nBalance2 = cBalance2 + amnt
  if nBalance1 > 0
    then do
      modChecking userIdF nBalance1 -- update sending acount
      modChecking userIdT nBalance2 -- update receiving account
      putStrLn "Transfer complete"
    else
      putStrLn "Insufficient funds"


-- checkingAmnt :: IO ()
checkingAmnt = do
  putStrLn "Pleaser enter User Id"
  userId <- readLn :: IO Int
  amnt <- getChecking userId
  print amnt

savingsAmnt = do
  putStrLn "PLease enter user Id"
  userId <- readLn ::IO Int
  amnt <- getSavings userId
  print amnt

removeUserUI :: IO()
removeUserUI = do
 putStrLn "Please enter User Id: "
 userId <- readLn :: IO Int
 removeUser userId
 putStrLn "Transaction completed"


addUserUI :: IO()
addUserUI = do
 putStrLn "Enter First Name: "
 fname <- getLine
 putStrLn "Enter Last Name: "
 lname <- getLine
 putStrLn "Enter amount for Checkings: "
 checkingAmount <- readLn :: IO Double
 print checkingAmount
 putStrLn "Enter amount for Savings: "
 savingAmount <- readLn :: IO Double
 print savingAmount
 addUser fname lname checkingAmount savingAmount
