require 'spec_helper'
require_relative 'shared'

describe "Korolev.konstructor included when another module that adds method_added" do

  context "when current class uses method added" do

  end

  context "when base class uses method_added" do
    let_klass(name: :base_klass) do

    end
  end

end