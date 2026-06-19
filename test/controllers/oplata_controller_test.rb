require "test_helper"

class OplataControllerTest < ActionDispatch::IntegrationTest
  def setup
    @oplatum = Oplatum.create(
      name: "Тестовое занятие",
      date: Date.today,
      duration: 1.0,
      pay: false,
      canceled: false
    )
  end

  # === CRUD тесты ===
  test "should get index" do
    get oplata_path
    assert_response :success
  end

  test "should get new" do
    get new_oplatum_path
    assert_response :success
  end

  test "should create oplatum" do
    assert_difference('Oplatum.count', 1) do
      post oplata_path, params: {
        oplatum: {
          name: "Новое занятие",
          date: Date.today,
          duration: 1.5,
          pay: false
        }
      }
    end
    assert_redirected_to oplata_path
    follow_redirect!
    assert_response :success
  end

  test "should not create oplatum without name" do
    assert_no_difference('Oplatum.count') do
      post oplata_path, params: {
        oplatum: {
          name: "",
          date: Date.today,
          duration: 1.5
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_oplatum_path(@oplatum)
    assert_response :success
  end

  test "should update oplatum" do
    patch oplatum_path(@oplatum), params: {
      oplatum: {
        name: "Обновленное занятие",
        payment_destination: "Т-Банк"
      }
    }
    @oplatum.reload
    assert_equal "Обновленное занятие", @oplatum.name
    assert_equal "Т-Банк", @oplatum.payment_destination
    assert_redirected_to oplata_path
    follow_redirect!
    assert_response :success
  end

  test "should toggle pay status" do
    patch oplatum_path(@oplatum), params: { oplatum: { pay: true } }
    @oplatum.reload
    assert @oplatum.pay

    patch oplatum_path(@oplatum), params: { oplatum: { pay: false } }
    @oplatum.reload
    assert_not @oplatum.pay
  end

  test "should toggle canceled status" do
    patch oplatum_path(@oplatum), params: { oplatum: { canceled: true } }
    @oplatum.reload
    assert @oplatum.canceled

    patch oplatum_path(@oplatum), params: { oplatum: { canceled: false } }
    @oplatum.reload
    assert_not @oplatum.canceled
  end

  test "should destroy oplatum" do
    assert_difference('Oplatum.count', -1) do
      delete oplatum_path(@oplatum)
    end
    assert_redirected_to oplata_path
    follow_redirect!
    assert_response :success
  end

  test "should show recently paid" do
    get recently_paid_oplata_path
    assert_response :success
  end

  test "should show dashboard" do
    get dashboard_oplata_path
    assert_response :success
  end
end