module UI where
import BuildData

--testDisplayUsers = displayUsers
--testAddUser = addUser "Tochi" "Tran"

main :: IO()
main = do
 putStrLn "Menu of HaskeshBank: "
 putStrLn "1: To add User"
 putStrLn "2: Display all Users"
 putStrLn "3: Check checking balance"
 putStrLn "4: Check savings balance"
 putStrLn "5: Remove User"
 putStrLn "6: Exit"
 option <- readLn :: IO Int
 if(option == 1) then addUserUI
  else if (option == 2) then displayUsers
  else if (option == 3) then checkingAmnt
  else if (option == 4) then savingsAmnt
  else if (option == 5) then removeUserUI
  else if (option == 6) then return () else return()

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
