module UI where
import BuildData

--testDisplayUsers = displayUsers
--testAddUser = addUser "Tochi" "Tran"

main :: IO()
main = do 
 putStrLn "Menu of HaskeshBank: "
 putStrLn "1: To add User"
 putStrLn "2: Display all Users"
 putStrLn "3: Check balance"
 putStrLn "4: Remove User"
 putStrLn "5: Exit"
 option <- readLn :: IO Int 
 if(option == 1) then addUserUI
  else if (option == 2) then displayUsers
  else if (option == 4) then removeUserUI
  else if (option == 5) then return () else return()

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