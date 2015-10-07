defmodule BankAccount do
  defmodule Action do
    defstruct type: nil, value: 0
  end

  def start, do: await []

  def await actions do
    receive do
      { :check_balance, pid }         -> send_balance pid, actions
      action = { :deposit,  _amount } -> append action, actions
      action = { :withdraw, _amount } -> append action, actions
    end
  end

  defp send_balance pid, actions do
    Process.send pid, { :balance, calc_balance(actions) }, []
    await actions
  end

  defp calc_balance actions do
    Enum.reduce actions, 0, &balance_reducer/2
  end

  defp balance_reducer({ :deposit,  value }, acc), do: acc + value
  defp balance_reducer({ :withdraw, value }, acc), do: acc - value
  defp balance_reducer(_action, acc),              do: acc

  defp append(action = { :withdraw, value }, actions) do
    if calc_balance(actions) < value do
      await actions
    else
      await [action | actions]
    end
  end
  defp append(action, actions), do: await [action | actions]
end
