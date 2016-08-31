{include file='common/header.tpl'}
{include file='common/menu.tpl'}

<div class="container-fluid">
	<div class="row">
		{include file='common/sidebar.tpl'}
		<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
			<div class="theme-showcase" role="main">
				
				{include file='common/result_messages.tpl'}

				<ol class="breadcrumb">
					<li><a href="{$BASE_URL}pages/users/main.php">Home</a></li>
					<li class="active">Create Exam</li>
				</ol>

				<form class="form-create-exam" method="post" action="{$BASE_URL}actions/exams/create.php">
					<input type="hidden" name="csrf_token" value="{$CSRF_TOKEN}" />
					<h2 class="form-signin-heading">Enter the new exam's information below</h2>

					<label for="inputExam" class="sr-only">Exam name</label>
					<input type="text" name="examName" id="inputExam" class="form-control" placeholder="Exam name" 
					data-toggle="tooltip" title="Insert the name for the new exam"
					required autofocus>
					<br/>

					<label for="inputDescription" class="sr-only">Exam description</label>
					<textarea id="inputDescription" name="examDescription" class="form-control" placeholder="Exam description" rows="10" 
					data-toggle="tooltip" title="Write an explicit description for the new exam"
					required></textarea>
					<br/>

					<div class="row">
						<div class='col-md-3'>
							<div class="form-group">
								<div class='input-group date' id='startDate'>
									<input type='text' id="starttime" class="form-control" placeholder="Exam Starts At" name='startDate'
									data-toggle="tooltip" title="Define a starting date and hour for the exam"/>
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>
							</div>
						</div>
						<div class='col-md-3'>
							<div class="form-group">
								<div class='input-group date' id='endDate'>
									<input type='text' id="endtime" class="form-control" placeholder="Exam Ends At" name="endDate"
									data-toggle="tooltip" title="Define a ending date and hour for the exam (Optional)"/>
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>
							</div>
						</div>
					</div>

					<br/>
					<label for="inputMaxTries">Maximum number of tries</label>
					<input type="number" name="examMaxTries" id="inputMaxTries" class="form-control" min="0" required value="1"
					data-toggle="tooltip" title="Choose the number of maximum tries for this exam">
					<br/> <br/>

					{if !isStudent()}
					<label><strong>Privacy:</strong></label>
					<input type="checkbox" class="examType" name="privacy" data-on-text="Public" data-off-text="Private" checked>

					<div class="alert alert-warning examTypeWarning" role="alert">
						<strong>Warning!</strong> Closed exams can only be seen by users you later invite to them.
					</div>
					{/if}
					<br/>
					<br/>

					<button class="btn btn-lg btn-primary" type="submit">Create Exam</button>
				</form>

			</div>
		</div>
	</div>





</div>
<!-- /container -->

{include file='common/footer.tpl'}
<script type="text/javascript" src="{$BASE_URL}frameworks/bootstrap-switch.min.js"></script>	
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.9.0/moment.min.js"></script>
<script type="text/javascript" src="{$BASE_URL}frameworks/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="{$BASE_URL}frameworks/en-gb.js"></script>
<script type="text/javascript" src="{$BASE_URL}javascript/exams/create.js"></script>

