defmodule BankAccountTest do
  use ExUnit.Case
  doctest BankAccount

  test "bank account to start out empty" do
    pid = new_account
      |> send_msg({ :check_balance, self })

    assert_receive { :balance, 0 }
  end

  test "can deposit moneys" do
    pid = new_account
      |> send_msg({ :deposit, 50 })
      |> send_msg({ :check_balance, self })

    assert_receive { :balance, 50 }
  end

  test "can withdraw moneys" do
    pid = new_account
      |> send_msg({ :deposit, 50 })
      |> send_msg({ :withdraw, 20 })
      |> send_msg({ :check_balance, self })

    assert_receive { :balance, 30 }
  end

  ### helpers

  def new_account do
    spawn BankAccount, :start, []
  end

  def send_msg pid, msg do
    Process.send pid, msg, []
    pid
  end
end
