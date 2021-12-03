defmodule FitlogWeb.ReportControllerTest do
  use FitlogWeb.ConnCase

  alias Fitlog.Reports
  alias Fitlog.Reports.Report

  @create_attrs %{
    calories: "120.5",
    carbs: "120.5",
    date: ~D[2010-04-17],
    dumbbell_sets: 42,
    dumbell_weight: "120.5",
    fat: "120.5",
    protein: "120.5",
    stepper_steps: 42,
    steps: 42,
    weight: "120.5"
  }
  @update_attrs %{
    calories: "456.7",
    carbs: "456.7",
    date: ~D[2011-05-18],
    dumbbell_sets: 43,
    dumbell_weight: "456.7",
    fat: "456.7",
    protein: "456.7",
    stepper_steps: 43,
    steps: 43,
    weight: "456.7"
  }
  @invalid_attrs %{
    calories: nil,
    carbs: nil,
    date: nil,
    dumbbell_sets: nil,
    dumbell_weight: nil,
    fat: nil,
    protein: nil,
    stepper_steps: nil,
    steps: nil,
    weight: nil
  }

  def fixture(:report) do
    {:ok, report} = Reports.create_report(@create_attrs)
    report
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all reports", %{conn: conn} do
      conn = get(conn, Routes.report_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create report" do
    test "renders report when data is valid", %{conn: conn} do
      conn = post(conn, Routes.report_path(conn, :create), report: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.report_path(conn, :show, id))

      assert %{
               "id" => _id,
               "calories" => "120.5",
               "carbs" => "120.5",
               "date" => "2010-04-17",
               "dumbbell_sets" => 42,
               "dumbell_weight" => "120.5",
               "fat" => "120.5",
               "protein" => "120.5",
               "stepper_steps" => 42,
               "steps" => 42,
               "weight" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.report_path(conn, :create), report: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update report" do
    setup [:create_report]

    test "renders report when data is valid", %{conn: conn, report: %Report{id: id} = report} do
      conn = put(conn, Routes.report_path(conn, :update, report), report: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.report_path(conn, :show, id))

      assert %{
               "id" => _id,
               "calories" => "456.7",
               "carbs" => "456.7",
               "date" => "2011-05-18",
               "dumbbell_sets" => 43,
               "dumbell_weight" => "456.7",
               "fat" => "456.7",
               "protein" => "456.7",
               "stepper_steps" => 43,
               "steps" => 43,
               "weight" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, report: report} do
      conn = put(conn, Routes.report_path(conn, :update, report), report: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete report" do
    setup [:create_report]

    test "deletes chosen report", %{conn: conn, report: report} do
      conn = delete(conn, Routes.report_path(conn, :delete, report))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.report_path(conn, :show, report))
      end
    end
  end

  defp create_report(_) do
    report = fixture(:report)
    %{report: report}
  end
end
