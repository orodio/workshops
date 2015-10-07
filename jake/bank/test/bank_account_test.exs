defmodule BankAccountTest do
  use ExUnit.Case

  test "Bank Account Starts With $0" do
    init_account
    |> send_message({ :check_balance, self })

    assert_receive { :balance, 0 }
  end

  test "Can deposit money into bank account" do
    init_account
    |> send_message({ :deposit, 50 })
    |> send_message({ :check_balance, self })

    assert_receive { :balance, 50 }
  end

  test "Can withdraw money from bank account" do
    init_account
    |> send_message({ :deposit, 50 })
    |> send_message({ :withdraw, 30 })
    |> send_message({ :check_balance, self })

    assert_receive { :balance, 20 }
  end

  test "Can transfer money from bank_account_1 account to bank_account_2" do
    bank_account_1 = init_account |> send_message({ :deposit, 50 })
    bank_account_2 = init_account

    send_message(bank_account_1, {:transfer, bank_account_2, 30})

    send_message(bank_account_1, {:check_balance, self})
    assert_receive { :balance, 20 }

    send_message(bank_account_2, {:check_balance, self})
    assert_receive { :balance, 30 }
  end

  def send_message(pid, message) do
    Process.send(pid, message, [])
    pid
  end

  def init_account do
    spawn(BankAccount, :start, [])
  end

  test "calc_balance" do
    events = [deposit: 50, withdraw: 30, deposit: 20, withdraw: 10]
    assert BankAccount.calc_balance(events) == 30
  end

  test "send_balance" do
    events = [deposit: 50, withdraw: 30, deposit: 20, withdraw: 10]
    BankAccount.send_balance(events, self)
    assert_receive { :balance, 30 }
  end
end
