require 'test_helper'

class ServiceWorkerControllerTest < ActionDispatch::IntegrationTest
  test "should get file" do
    get service_worker_file_url
    assert_response :success
  end

  test "should get manifest" do
    get service_worker_manifest_url
    assert_response :success
  end

end
