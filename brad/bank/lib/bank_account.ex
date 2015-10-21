defmodule BankAccount do
  def start, do: await []



  def await history do
    receive do
              { :check_balance, pid } -> send_balance pid, history
      event = { :deposit, _amount }   -> history = [event | history]
      event = { :withdraw, _amount }  -> history = [event | history]
              { :munge_history }      -> history = munge_history(history)
    end

    await history
  end



  def send_balance pid, history do
    Process.send pid, { :balance, calc_balance(history) }, []
  end



  @doc """
    Calculates the Balance

    iex> BankAccount.calc_balance [deposit: 50, withdraw: 30]
    20
  """
  def calc_balance history do
    history
    |> Enum.reduce(0, &balance_reducer/2)
  end



  @doc """
    reducer function for calc_balance

    iex> BankAccount.balance_reducer({:deposit, 50}, 0)
    50

    iex> BankAccount.balance_reducer({:withdraw, 50}, 0)
    -50

    iex> BankAccount.balance_reducer({:other, 999, "woot"}, 0)
    0
  """
  def balance_reducer({ :deposit, amount }, acc),  do: acc + amount
  def balance_reducer({ :withdraw, amount }, acc), do: acc - amount
  def balance_reducer(_event, acc),                do: acc



  @doc """
    Calculate the total withdraws

    iex> BankAccount.calc_withdraws [withdraw: 50, withdraw: 30, deposit: 100]
    80
  """
  def calc_withdraws history do
    history
    |> Enum.filter(&is_withdraw/1)
    |> calc_balance
    |> abs
  end



  @doc """
    Calculate the total deposits

    iex> BankAccount.calc_deposits [deposit: 50, deposit: 30, withdraw: 30]
    80
  """
  def calc_deposits history do
    history
    |> Enum.filter(&is_deposit/1)
    |> calc_balance
  end



  @doc """
    Predicate that says an event is a withdraw

    iex> BankAccount.is_withdraw {:deposit, 50}
    false

    iex> BankAccount.is_withdraw {:withdraw, 40}
    true

    iex> BankAccount.is_withdraw {:other, 999, "woot"}
    false
  """
  def is_withdraw({type, _amount}), do: type == :withdraw
  def is_withdraw(_event), do: false



  @doc """
    Predicate that says an event is a deposit

    iex> BankAccount.is_deposit {:deposit, 50}
    true

    iex> BankAccount.is_deposit {:withdraw, 40}
    false

    iex> BankAccount.is_deposit {:other, 999, "woot"}
    false
  """
  def is_deposit({type, _amount}), do: type == :deposit
  def is_deposit(_event), do: false



  @doc """
    munges the history

    iex> BankAccount.munge_history [deposit: 50, deposit: 30, withdraw: 20, withdraw: 10, other: 999]
    [withdraw: 30, deposit: 80]
  """
  def munge_history history do
    [withdraw: calc_withdraws(history), deposit: calc_deposits(history)]
  end
end
