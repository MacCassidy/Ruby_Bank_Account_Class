#Rspec is a Ruby testing Framework, you might call it a "Domain-specific-language" for testing, It's taken ruby and added additional language features on top of it for testing your code
require './bank_account'
#this isn't in the current directory of the this file I know, but it looks for it from the point of view of the bank_account file

#running rspec while in the project folder or "oob_bank" it will find and list this shit "rspec" is for ruby code only, it is native to ruby.
describe BankAccount do

  it "is created with an opening balance and the name of the client" do
    account = BankAccount.new(500, "Mac")
    expect(account).to be_a(BankAccount)
    #this expects what you throw into it matches to something(in this case a class), it's a lot like english
  end

  it "can report it's balance" do
    account = BankAccount.new(500, "Mac")
    expect(account.balance).to eq(500)
  end

  it "can make deposit"do
    account = BankAccount.new(500, "Mac")
    account.deposit(500)
    expect(account.balance).to eq(1000)
  end

  it "can make withdrawals, of the cash that they currently have."do
    account = BankAccount.new(400, "Mac")
    account.withdraw(200)
    expect(account.balance).to eq(200)
  end

  it "can tranfer funds between accounts"do
    account1 = BankAccount.new(500, "Mac")
    account2 = BankAccount.new(500, "Cole")
    account1.transfer(200,account2)
    expect(account1.balance).to eq(300)
    expect(account2.balance).to eq(700)
  end

  it "raise's an error when attempting to transfer money to an account that doesn't exist"do
    account1 = BankAccount.new(500, "Mac")
    expect{account1.transfer(400, "non_existant_account")}.to raise_error(ArgumentError)
  end

  it "has a minimum opening balance, and raises an error when attempt to create a BankAccount with less than the minimum" do
    expect {account = BankAccount.new(50, "Mac")}.to raise_error(ArgumentError)
  end

  it "allows the banker to change the minimum opening balance"do
    BankAccount.min_opening_balance = 400
    expect {account = BankAccount.new(300, "Mac")}.to raise_error(ArgumentError)
    expect {account = BankAccount.new(500, "Mac")}.to_not raise_error(ArgumentError)
  end

  it "can show it's current overdraft fee"do
    expect(BankAccount.current_overdraft_fee).to eq(25)
  end

  it "can let banker change overdraft fee"do
    BankAccount.overdraft_fee = 35
    expect(BankAccount.current_overdraft_fee).to eq(35)
  end

  it "applies an over draft fee to an account when they withdraw more than what their current balance is."do
    account = BankAccount.new(500, "Mac")
    BankAccount.overdraft_fee = 25
    account.withdraw(600)
    expect(account.balance).to eq(-125)
    account.withdraw(100)
    expect(account.balance).to eq(-250)
  end

  it "applies overdraft fee to an account when the account transfers more than what it's balance is"do
    BankAccount.overdraft_fee = 25
    account1 = BankAccount.new(500, "Mac")
    account2 = BankAccount.new(500, "Devin")
    account1.transfer(600, account2)
    expect(account1.balance).to eq(-125)
  end

  it "can show a running transaction history for every bank account"do
    account1 = BankAccount.new(500, "Mac")
    expect(account1.account_history[0][:type]).to eq("opening")
    expect(account1.account_history[0][:balance]).to eq(500)
    expect(account1.account_history[0][:name]).to eq("Mac")
    account1.deposit(500)
    expect(account1.account_history[1][:type]).to eq("deposit")
    expect(account1.account_history[1][:amount]).to eq(500)
    expect(account1.account_history[1][:balance_after]).to eq(1000)
  end

  it "can store transaction history of a BankAccount instance on another file as a backup"do
    account1 = BankAccount.new(500, "Mac")
    account1.deposit(500)
    expect(File.exist?("Mac")).to eq(true)
  end

  it "can Recover a bank account from it's transaction history"do
    account1 = BankAccount.new(500, "Mac")
    account1.deposit(500)
    account1_clone = BankAccount.restore_account("Mac")
    expect(account1_clone.balance).to eq(1000)
  end

end
