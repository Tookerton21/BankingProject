module UI where
import BuildData
import Data.Time.Clock
import Data.Time.Calendar
--testDisplayUsers = displayUsers
--testAddUser = addUser "Tochi" "Tran"

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
 putStrLn "8: Display Transaction History"
 putStrLn "9: Exit"
 option <- readLn :: IO Int
 if(option == 1) then addUserUI
  else if (option == 2) then displayUsers
  else if (option == 3) then checkingAmnt
  else if (option == 4) then savingsAmnt
  else if (option == 5) then removeUserUI
  else if (option == 6) then tranMoney
  else if (option == 7) then tranStoC
  else if (option == 8) then displayH
  else if (option == 9) then return () else return()

displayH = do
  putStrLn "Enter User Id"
  userId <- readLn :: IO Int
  displayHistory userId

tranStoC = do
  putStrLn "Enter User Id"
  userId <- readLn :: IO Int

  putStrLn "Amount to transfer to Checking"
  amnt <- readLn :: IO Double

  cBalance1 <- getSavings userId
  cBalance2 <- getChecking userId
  let nBalance1 = cBalance1 - amnt
  let nBalance2 = cBalance2 + amnt
  now <- getCurrentTime
  let (year, month, day) = toGregorian $ utctDay now

  if nBalance1 > 0
    then do
      modSavings userId nBalance1
      updateHistory userId "savings" (negate amnt) day month year
      modChecking userId nBalance2
      updateHistory userId "checking" amnt day month year
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

  -- Get the current day
  now <- getCurrentTime
  let (year, month, day) = toGregorian $ utctDay now

  cBalance1 <- getChecking userIdF -- balance from sending account
  cBalance2 <- getChecking userIdT -- balance for receiving account
  let nBalance1 = cBalance1 - amnt  -- new balance from sending account
  let nBalance2 = cBalance2 + amnt
  if nBalance1 > 0
    then do
      modChecking userIdF nBalance1 -- update sending acount
      updateHistory userIdF "checking" (negate amnt) day month year
      modChecking userIdT nBalance2 -- update receiving account
      updateHistory userIdT "checking" amnt day month year
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
