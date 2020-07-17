<%@ include file="/init.jsp"%>

<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>

<link href="https://cdn.datatables.net/1.10.9/css/jquery.dataTables.css"
	rel="stylesheet" type="text/css" />
<script src="https://cdn.datatables.net/1.10.9/js/jquery.dataTables.js"></script>

<style>  
tfoot {
    display: table-header-group;
}
</style>

<%!List<WorkflowDTO> workflowDTOList = new ArrayList<>();%>
<%
	if (renderRequest.getAttribute("workflowDTOList") != null) {

		workflowDTOList = (List<WorkflowDTO>) renderRequest.getAttribute("workflowDTOList");
	}
%>



<table id="mySubmissionsTable" class="display" cellspacing="0"
	width="100%">

<tfoot>
		<tr>
			<th> </th>
			<th>Filter by status :</th>
			<th> </th>
			<th> </th>
			<th> </th>
			<th> </th>
		</tr>
	</tfoot>
	<thead>
		<tr>
			<th>Asset Title</th>
			<th>Asset Type</th>
			<th>Status</th>
			<th>Definition</th>
			<th>Last Activity Date</th>
			<th>End Date</th>
		</tr>
	</thead>
	
	<tbody>
		<c:forEach var="workflowDTO" items="${workflowDTOList}">

			<portlet:renderURL var="rowURL">
				<portlet:param name="mvcPath" value="/view_content.jsp" />
				<portlet:param name="assetEntryId"
					value="${workflowDTO.assetEntryId}" />
				<portlet:param name="assetRendererType"
					value="${workflowDTO.assetRendererType}" />
				<portlet:param name="assetEntryVersionId"
					value="${workflowDTO.assetEntryVersionId}" />
				<portlet:param name="entryClassName"
					value="${workflowDTO.entryClassName}" />
				<portlet:param name="redirect" value="<%=currentURL%>" />
			</portlet:renderURL>

			<tr data-href="<%=rowURL%>">
				<td>${workflowDTO.assetTitle}</td>
				<td>${workflowDTO.assetType}</td>
				<td>${workflowDTO.status}</td>
				<td>${workflowDTO.definition}</td>
				<td>${workflowDTO.lastActivityDate}</td>
				<td>${workflowDTO.endDate}</td>
			</tr>
		</c:forEach>

	</tbody>
</table>

<script>
	$(document).ready(function() {
		var table = 	$('#mySubmissionsTable').dataTable({
			"columnDefs" : [ {
				"targets" : [ 0 ],
				"visible" : true,
				"searchable" : true
			}],
			initComplete: function () {
	            this.api().columns(2).every( function () {
	                var column = this;
	                var select = $('<select><option value="">all</option></select>')
	                    .appendTo( $(column.footer()).empty() )
	                    .on( 'change', function () {
	                        var val = $.fn.dataTable.util.escapeRegex(
	                            $(this).val()
	                        );

	                        column
	                            .search( val ? '^'+val+'$' : '', true, false )
	                            .draw();
	                    } );

	                column.data().unique().sort().each( function ( d, j ) {
	                    select.append( '<option value="'+d+'">'+d+'</option>' )
	                } );
	            } );
	        }
		});
		} );

	$(document).ready(function() {
		$(document.body).on("click", "tr[data-href]", function() {
			window.location.href = this.dataset.href;
		});
	});
	
	$(document).ready(function () {
	    $("#mySubmissionsTable tr").css('cursor', 'pointer');
	});

	
</script>









<!-- TODO -->
<%
	if (true == false) {
%>
<liferay-ui:icon-menu cssClass="lfr-asset-actions" direction="left-side"
	icon="<%=StringPool.BLANK%>" markupView="lexicon"
	message="<%=StringPool.BLANK%>" showWhenSingleIcon="<%=true%>">


	<portlet:renderURL var="redirectURL">
		<portlet:param name="mvcPath" value="/view.jsp" />
		<portlet:param name="tab"
			value="<%=WorkflowWebKeys.WORKFLOW_TAB_INSTANCE%>" />
	</portlet:renderURL>

	<portlet:actionURL name="deleteWorkflowInstance" var="deleteURL">
		<portlet:param name="redirect" value="<%=redirectURL%>" />
		<portlet:param name="companyId" value="${workflowDTO.companyId}" />
		<portlet:param name="groupId" value="${workflowDTO.groupId}" />
		<portlet:param name="entryClassName"
			value="${workflowDTO.entryClassName}" />
		<portlet:param name="entryClassPK"
			value="${workflowDTO.assetEntryVersionId}" />
	</portlet:actionURL>

	<liferay-ui:icon message="withdraw-submission" url="<%=deleteURL%>" />
</liferay-ui:icon-menu>
<%
	}
%>