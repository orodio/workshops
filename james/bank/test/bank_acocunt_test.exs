defmodule BankAccountTest do
  use ExUnit.Case
  doctest Bank

  test "Bank Account starts with no moneys" do
    new_bank_account
      |> send_msg({ :check_balance, self })

    assert_receive { :balance, 0 }
  end

  test "Can deposit moneys into Bank Account" do
    new_bank_account
      |> send_msg({ :deposit, 10 })
      |> send_msg({ :check_balance, self })

    assert_receive { :balance, 10 }
  end

  test "Can withdraw moneys into Bank Account" do
    new_bank_account
      |> send_msg({ :deposit, 20 })
      |> send_msg({ :withdraw, 10 })
      |> send_msg({ :check_balance, self })

    assert_receive { :balance, 10 }
  end

  test "Cannot withdraw money from Bank Account if there are no moneys" do
    new_bank_account
      |> send_msg({ :deposit, 10 })
      |> send_msg({ :withdraw, 30 })
      |> send_msg({ :check_balance, self })

    assert_receive { :balance, 10 }
  end

  defp new_bank_account do
    spawn BankAccount, :start, []
  end

  defp send_msg pid, msg do
    Process.send pid, msg, []
    pid
  end
end
