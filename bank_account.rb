class BankAccount

  attr_accessor :account_history
  attr_accessor :balance
  attr_accessor :name
  @@min_opening_balance = 200
  @@overdraft_fee = 25

  def initialize(opening_balance, name)
    raise ArgumentError, "Sorry, the minimum opening balance is #{@@min_opening_balance}" if opening_balance < @@min_opening_balance
    @name = name
    @balance = opening_balance
    @account_history = []
    @account_history << {type: "opening", balance: opening_balance, name: name}
    File.open(name, "w"){|x| x.write(Marshal.dump(self))}
  end

  def deposit(amount)
    @balance += amount
    @account_history << {type: "deposit", amount: amount, balance_after: @balance}
    File.open(name, "w"){|x| x.write(Marshal.dump(self))}
  end

  def withdraw(amount)
    if (@balance - amount) < 0
      @balance -= (amount + @@overdraft_fee)
    else
      @balance -= amount
    end
    @account_history << {type: "withdrawal", amount: amount, balance_after: @balance }
    File.open(name, "w"){|x| x.write(Marshal.dump(self))}
  end

  def transfer(amount, account)
    if account.is_a? BankAccount
      if amount > @balance
        account.balance += amount
        @balance -= (amount + @@overdraft_fee)
        @account_history << {type: "trans_to", amount: amount, to: account.name, balance_after: @balance}
        account.transfer_received_loger(amount, @name)
        File.open(name, "w"){|x| x.write(Marshal.dump(self))}
      else
        account.balance += amount
        @balance -= amount
        @account_history << {type: "trans_to", amount: amount, to: account.name, balance_after: @balance}
        account.transfer_received_loger(amount, @name)
        File.open(name, "w"){|x| x.write(Marshal.dump(self))}
      end
    else
      raise ArgumentError, "You can't transfer to a bank account that doesn't exist"
    end
  end

  def transfer_received_loger(amount, name)
    @account_history << {type: "trans_from", amount: amount, from: name, balance_after: @balance}
    File.open(name, "w"){|x| x.write(Marshal.dump(self))}
  end

  def self.min_opening_balance=(amount)
    @@min_opening_balance = amount
  end

  def self.current_overdraft_fee
    return @@overdraft_fee
  end

  def self.overdraft_fee=(amount)
      @@overdraft_fee = amount
  end

  def self.history(account)
    if account.is_a? BankAccount
      account.account_history.each{ |x|
                                  if x[:type] == "opening"
                                    puts "#{x[:name]} opened with an opening balance of #{x[:balance]}"
                                  elsif x[:type] == "deposit"
                                    puts "#{x[:amount]} was deposited #{x[:balance_after]} is the balance after."
                                  elsif x[:type] == "withdrawal"
                                    puts "#{x[:amount]} was withdrawn, the new balance is #{x[:balance_after]}"
                                  elsif x[:type] == "trans_to"
                                    puts "#{x[:amount]} was transfered to #{x[:to]}, the new balance is #{x[:balance_after]} "
                                  elsif x[:type] == "trans_from"
                                    puts "#{x[:amount]} was transfered to you from #{x[:from]}, your new balance is #{x[:balance_after]}"
                                  end
                                  }
    else
      raise ArgumentError, "Sorry, that bank account doesn't exist"
    end
  end

  def self.restore_account(name)
    if File.exist?(name)
      return Marshal.load(File.read(name))
    end
  end
  
end
