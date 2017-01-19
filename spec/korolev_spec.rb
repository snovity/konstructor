require 'spec_helper'

describe Korolev do
  it "has a version number" do
    expect(Korolev::VERSION).not_to be nil
  end

  subject {[ instance.one, instance.two, instance.three ]}

  # TODO: must be shared for one and for two constructor
  context ".constructors" do

    context "via name" do
      let(:dummy_class) do
        Class.new do
          include Korolev

          konstructor :mamba

          attr_reader :one, :two

          def mamba(one, two)
            @one = one
            @two = two
          end
        end
      end

      context "for one name" do
        subject(:instance) { dummy_class.mamba(1, 2) }

        specify do
          expect(instance.one).to eq 1
          expect(instance.two).to eq 2
        end
      end

      context "for two names" do
        let(:dummy_class) do
          Class.new do
            include Korolev

            konstructor :mamba, :bimba

            attr_reader :one, :two, :three

            def mamba(one, two)
              @one = one
              @two = two
            end

            def bimba(three)
              @three = three
            end
          end
        end

        context "via first constructor" do
          let(:instance) { dummy_class.mamba(1, 2) }

          it { is_expected.to eq [1, 2, nil] }
        end

        context "via second consturctor" do
          let(:instance) { dummy_class.bimba(3) }

          it { is_expected.to eq [nil, nil, 3] }
        end
      end

      context "doesn't expose to outside" do
        context "instance constructor methods" do
          let(:instance) { dummy_class.mamba(1, 2) }

          specify do
            expect { instance.mamba(3, 4) }.to raise_error(NoMethodError)
            expect(instance.one).to eq 1
            expect(instance.two).to eq 2
          end
        end

        context "DSL method" do
          subject { dummy_class.constructors :one }

          specify do
            expect { subject }.to raise_error(NoMethodError)
          end
        end
      end

      context "works with blocks"

      context "raises error if initialize or new given"

      context "when subclassed and super called"
    end

    context "via placement" do
      let(:dummy_class) do
        Class.new do
          include Korolev

          attr_reader :one, :two, :three

          konstructor
          def mamba(one, two)
            @one = one
            @two = two
          end

          def bimba(three)
            @three = three
          end
        end
      end

      context "for one constructor" do
        let(:instance) { dummy_class.mamba(1, 2) }

        context "when it is called" do
          it { is_expected.to eq [1, 2, nil] }
        end

        context "when next method is called" do
          subject { dummy_class.bimba }

          specify { expect { subject }.to raise_error(NoMethodError) }
        end
      end
    end

    context "when nothing is declared" do
      let(:dummy_class) do
        Class.new do
          include Korolev

          attr_reader :one, :two, :three

          def mamba(one, two)
            @one = one
            @two = two
          end

          def bimba(three)
            @three = three
          end
        end
      end

      context "no constructor is defined" do
        subject { dummy_class.mamba }

        specify { expect { subject }.to raise_error(NoMethodError) }
      end

      context "methods stay public" do
        let(:instance) { dummy_class.new }

        specify do
          instance.mamba(1, 2)
          is_expected.to eq [1, 2, nil]
        end
      end


    end

    # WHAT ABOUT WHEN DECLARATION USED IN MODULE AND IT IS INCLUDED,
    # maybe just raise an error?
  end
end
