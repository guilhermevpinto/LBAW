<div id="exam-element-{$examElement.id}" class="panel-body question exam-element">
	<div class="panel panel-primary">
		<div class="panel-heading exam-element-heading">
			<div class="row">
				<div class="col-md-6 question-statement-container">
					<div class="inline-editable question-statement" name="statement" data-id="{$question.id}">{$question.statement|escape:'html'}</div>
				</div>
				<div class="col-md-6 text-right">
					<span class="icon-clickable">
						<i class="fa fa-trash-o" data-questionid="{$question.id}" data-toggle="modal" data-target="#confirmationModalDeleteQuestion"></i>
					</span>
				</div>
			</div>
		</div>
		<div class="panel-body">
			<input type="hidden" name="csrf_token" value="{$CSRF_TOKEN}" />
			
			{foreach $question.answers as $answer}
			<div class="radio answer">
				{if $answer.score > 0}
					{assign scoreType positive}
				{else if $answer.score < 0}
					{assign scoreType negative}
				{else}
					{assign scoreType neutral}
				{/if}
				<span class="icon-clickable delete-answer" data-answerid="{$answer.id}"><i class="fa fa-trash-o"></i></span><!--
			 --><div class="inline-editable no-full-width answer-score {$scoreType}" type="number" name="score" data-id="{$answer.id}">{$answer.score}</div>
				<label{if $isEditing} disabled{/if}>
					<input type="radio" name="optradio1"{if $isEditing} disabled{/if}>
					<div class="inline-editable answer-text" name="text" data-id="{$answer.id}"{if $isEditing} disabled{/if}>{$answer.text|escape:'html'}</div>
				</label>
			</div>
			{/foreach}
			
			<form class="add-answer" data-id={$answer.id}>
				<i class="fa fa-plus"></i>
				<input type="hidden" name="questionid" value="{$question.id}"/>
				<input type="text" name="text" placeholder="Add answer"/>
			</form>
		</div>
	</div>
</div>