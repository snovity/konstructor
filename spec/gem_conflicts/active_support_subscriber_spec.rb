require 'spec_helper'

describe "Konstructor with Thor" do

  before :all do
    require 'konstructor'
    require 'active_support/subscriber'
    require 'active_support/notifications'
  end

  before :all do
    class TestSubscriber < ActiveSupport::Subscriber
      attr_accessor :zero, :one, :two, :three

      def before_attached(event)
        @one = event.payload[:one]
      end

      konstructor
      def betta(three)
        @three = three
      end
    end

    TestSubscriber.attach_to :test_namespace

    class TestSubscriber
      def after_attached(event)
        @two = event.payload[:two]
      end
    end
  end

  context "method defined after attaching continues to work" do
    let(:instance) do
      ActiveSupport::Notifications.instrument('before_attached.test_namespace', one: 111)
      ActiveSupport::Notifications.instrument('after_attached.test_namespace', two: 2)
      TestSubscriber.subscribers.last
    end

    specify { expect_instance_state nil, 111, 2, nil }
  end

  context "konstructor works" do
    let(:instance) { TestSubscriber.betta(333) }

    specify { expect_instance_state nil, nil, nil, 333 }
  end

end