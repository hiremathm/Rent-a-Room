require 'test_helper'

class AmenityRoomsControllerTest < ActionController::TestCase
  setup do
    @amenity_room = amenity_rooms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:amenity_rooms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create amenity_room" do
    assert_difference('AmenityRoom.count') do
      post :create, amenity_room: { room_id: @amenity_room.room_id }
    end

    assert_redirected_to amenity_room_path(assigns(:amenity_room))
  end

  test "should show amenity_room" do
    get :show, id: @amenity_room
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @amenity_room
    assert_response :success
  end

  test "should update amenity_room" do
    patch :update, id: @amenity_room, amenity_room: { room_id: @amenity_room.room_id }
    assert_redirected_to amenity_room_path(assigns(:amenity_room))
  end

  test "should destroy amenity_room" do
    assert_difference('AmenityRoom.count', -1) do
      delete :destroy, id: @amenity_room
    end

    assert_redirected_to amenity_rooms_path
  end
end
