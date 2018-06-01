module UI where
import BuildData

--testDisplayUsers = displayUsers
--testAddUser = addUser "Tochi" "Tran"

main = do


addUserUI :: IO ()
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