defmodule BankTest do
  import Process, only: [send: 3]
  use ExUnit.Case

  test "bank account starts out empty" do
    new_bank_account
    |> send_msg({ :check_balance, self })

    assert_receive { :balance, 0 }
  end

  test "we can deposit moneys" do
    new_bank_account
    |> send_msg({ :deposit, 50 })
    |> send_msg({ :check_balance, self })

    assert_receive { :balance, 50 }
  end

  test "we can withdraw moneys" do
    new_bank_account
    |> send_msg({ :deposit, 100 })
    |> send_msg({ :withdraw, 50 })
    |> send_msg({ :check_balance, self })

    assert_receive { :balance, 50 }
  end

  def new_bank_account, do: spawn Bank, :start, []

  def send_msg(pid, message) do
    send pid, message, []
    pid
  end
end
