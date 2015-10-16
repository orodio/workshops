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


  def send_message(pid, message) do
    Process.send(pid, message, [])
    pid
  end

  def init_account do
    spawn(BankAccount, :start, [])
  end
end
