{include file='common/header.tpl'} {include file='common/menu.tpl'}

<div class="container-fluid">
	<div class="row">
		{include file='common/sidebar.tpl'}
		<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
			<div class="container theme-showcase" role="main">

				{include file='common/result_messages.tpl'}

				<ol class="breadcrumb">
					<li><a href="main.php">Home</a></li>
					<li class="active">Remove Users</li>
				</ol>

				<form class="form-remove-user">
					<input type="hidden" name="csrf_token" value="{$CSRF_TOKEN}" />
					<h2 class="form-signin-heading">Remove user</h2>

					<label for="inputUserToRemove" class="sr-only">Full name</label>
					<input type="text" id="inputUserToRemove" class="form-control" placeholder="User name or email"
					data-toggle="tooltip" title="Insert the name or email of the user to be removed"
						required autofocus>
					<br/>
				</form>
				<br/><br/>

				<h2>User list:</h2>

				<table class="table table-striped">
					<thead>
						<tr>
							<th>ID</th>
							<th>Name</th>
							<th>Email</th>
							<th>Actions</th>
						</tr>
					</thead>
					<tbody>
						{foreach $users as $user}
						<tr id="{$user.id}">
							<td>{$user.id}</td>
							<td>{$user.name}</td>
							<td>{$user.email}</td>
							<td><a class="btn btn-danger" data-id="{$user.id}" href="#" data-toggle="modal" data-target="#confirmationModal">Remove</a></td>
						</tr>
						{/foreach}
					</tbody>
				</table>

				<div id="confirmationModal" class="modal fade" role="dialog">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header text-center">
								<button type="button" class="close" data-dismiss="modal">&times;</button>
								<h4 class="modal-title">Are you sure to delete this user?</h4>
							</div>
							<div class="modal-body text-center">
								<button type="button" id="yes" class="btn btn-success">Yes</button>
								<button type="button" id="no" class="btn btn-danger" data-dismiss="modal">No</button>
							</div>
						</div>
					</div>
				</div>
				<div class="text-center">
					{if $numberOfPages < 8}
						
						{for $i=1 to $currentPage-1}
							<a class="btn btn-primary" href="remove_users.php?page={$i}">{$i}</a>
						{/for}
						<a class="btn btn-primary active" href="remove_users.php?page={$currentPage}">{$currentPage}</a>
						{for $i=currentPage+1 to $numberOfPages}
							<a class="btn btn-primary" href="remove_users.php?page={$i}">{$i}</a>
						{/for}
					
					{else}

						{if $currentPage > 4}
							<a class="btn btn-primary" href="remove_users.php?page=1">First</a>
							{for $i=$currentPage - 3 to $currentPage-1}
								<a class="btn btn-primary" href="remove_users.php?page={$i}">{$i}</a>
							{/for}
						{else}
							{for $i=1 to $currentPage-1}
								<a class="btn btn-primary" href="remove_users.php?page={$i}">{$i}</a>
							{/for}
						{/if}
						<a class="btn btn-primary active" href="remove_users.php?page={$currentPage}">{$currentPage}</a>
						{if $currentPage + 3 < $numberOfPages}
							{for $i=$currentPage + 1 to $currentPage + 3}
								<a class="btn btn-primary" href="remove_users.php?page={$i}">{$i}</a>
							{/for}
							<a class="btn btn-primary" href="remove_users.php?page={$numberOfPages}">Last</a>
						{else}
							{for $i=$currentPage + 1 to $numberOfPages}
								<a class="btn btn-primary" href="remove_users.php?page={$i}">{$i}</a>
							{/for}
						{/if}

					{/if}
				</div>
			</div>
		</div>
	</div>

</div>


<!-- /container -->

{include file='common/footer.tpl'}
<script src="{$BASE_URL}javascript/admin/remove_users.js"></script>
<script src="{$BASE_URL}javascript/jquery.jeditable.js"></script>
<script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js" integrity="sha256-xNjb53/rY+WmG+4L6tTl9m6PpqknWZvRt0rO1SRnJzw=" crossorigin="anonymous"></script>
