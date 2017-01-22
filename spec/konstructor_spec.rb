require 'spec_helper'

describe Konstructor do
  it "has a version number" do
    expect(Konstructor::VERSION).not_to be nil
  end

  context ".is?" do
    subject { Konstructor.is?(klass, name) }

    context "for single class" do
      let_konstructor_klass do
        konstructor
        def_alpha
        def_betta
      end

      context "new" do
        let(:name) { :new }
        it { is_expected.to eq false }
      end

      context "alpha" do
        let(:name) { :initialize }
        it { is_expected.to eq true }
      end

      context "alpha" do
        let(:name) { :alpha }
        it { is_expected.to eq true }
      end

      context "alpha as string" do
        let(:name) { 'alpha' }
        it { is_expected.to eq true }
      end
    end

  end
end
