class MembersController < ApplicationController
  http_basic_authenticate_with name: ENV["USERNAME"], password: ENV["PASSWORD"]

  def index
    @members = Member.all
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        # Tell the UserMailer to send a welcome Email after save
        MemberMailer.welcome_email(@member).deliver

        format.html { redirect_to(action: :index, notice: 'Member was successfully created.') }
        format.json { render json: @member, status: :created, location: @member }
      else
        format.html { render action: 'new' }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    @member.update_attributes(params[:member])
    redirect_to action: :index
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy!
    redirect_to action: :index
  end

  def graph
    dict = {}
    edges = []
    node_data = []
    # create dict used by edge lines and write node lines
    Member.active.each_with_index do |member, i|
      switch_node_name = i
      dict[member.id] = switch_node_name
      node_data << { name: member.name }
    end

    # create edge lines
    Group.all.each do |group|
      pairwise_combos = group.members.active.pluck(:id).combination(2)
      pairwise_combos.each do |c|
        edges << [dict[c.first], dict[c.last]]
      end
    end
    @node_data_str = node_data.to_json.html_safe
    @link_data_str = edges.to_json.html_safe
  end

  def slack_import
    @slack_members = slack_users
  end

  def import_selected
    imported_slack_members.map do |member|
      member.groups.new(name: member.name)
      member.save
    end

    redirect_to members_path
  end

  private

  def slack_client
    @slack_client ||= Slack::Client.new
  end

  def imported_slack_members
    @imported_slack_users ||= params[:new_members].map do |user|
      parsed_user = JSON.parse(user)
      Member.new(
        name:     parsed_user['real_name'],
        email:    parsed_user['profile']['email'],
        slack_id: parsed_user['id']
      )
    end
  end

  def slack_users
    @slack_users ||= slack_client.users_list['members'].reject do |u|
      u['deleted']            ||
      u['is_bot']             ||
      u['is_restricted']      ||
      u['name'] == 'slackbot'
    end
  end

  def member_params
    params.require(:member).permit!
  end
end
