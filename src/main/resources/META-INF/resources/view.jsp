<%@ include file="/init.jsp" %>


<%@ taglib uri="http://liferay.com/tld/asset" prefix="liferay-asset" %><%@
taglib uri="http://liferay.com/tld/comment" prefix="liferay-comment" %><%@
taglib uri="http://liferay.com/tld/frontend" prefix="liferay-frontend" %><%@
taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>

<%@ page import="com.liferay.asset.kernel.AssetRendererFactoryRegistryUtil" %><%@
page import="com.liferay.asset.kernel.model.AssetEntry" %><%@
page import="com.liferay.asset.kernel.model.AssetRenderer" %><%@
page import="com.liferay.asset.kernel.model.AssetRendererFactory" %><%@
page import="com.liferay.petra.string.StringPool" %><%@
page import="com.liferay.portal.kernel.util.HtmlUtil" %><%@
page import="com.liferay.portal.kernel.util.StringUtil" %><%@
page import="com.liferay.portal.kernel.util.WebKeys" %><%@
page import="com.liferay.portal.kernel.workflow.WorkflowException" %><%@
page import="com.liferay.portal.kernel.workflow.WorkflowInstance" %><%@
page import="com.liferay.portal.kernel.workflow.WorkflowLog" %>



<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %><%@
taglib uri="http://liferay.com/tld/clay" prefix="clay" %><%@
taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %><%@
taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>

<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %><%@
page import="com.liferay.portal.workflow.constants.WorkflowWebKeys" %><%@
page import="com.liferay.portal.workflow.portlet.tab.WorkflowPortletTab" %><%@
page import="com.liferay.taglib.servlet.PipingServletResponse" %>

<%@ page import="java.util.List" %>

<%@ page import="javax.portlet.PortletURL" %>


<%!
List<WorkflowDTO> workflowDTOList=new ArrayList<>();
%>
<%
if(renderRequest.getAttribute("workflowDTOList")!=null){

	workflowDTOList=(List<WorkflowDTO>) renderRequest.getAttribute("workflowDTOList");
}
%>

<div class="form">
	<liferay-ui:input-search
		markupView="lexicon"
	/>
</div>

<liferay-ui:search-container delta="5" emptyResultsMessage="No records available" >
    <liferay-ui:search-container-results  results="<%= ListUtil.subList(workflowDTOList, searchContainer.getStart(), searchContainer.getEnd()) %>" />
    <liferay-ui:search-container-row className="com.rge.forms.workflow.submissions.dto.WorkflowDTO" keyProperty="id" modelVar="workflowDTO" >
    
    <portlet:renderURL var="rowURL">
			<portlet:param name="mvcPath" value="/view_content.jsp" />
			<portlet:param name="assetEntryId" value="${workflowDTO.assetEntryId}" />
			<portlet:param name="assetRendererType" value="${workflowDTO.assetRendererType}" />
			<portlet:param name="assetEntryVersionId" value="${workflowDTO.assetEntryVersionId}" />
			<portlet:param name="entryClassName" value="${workflowDTO.entryClassName}" />
			<portlet:param name="redirect" value="<%=currentURL%>" />
		</portlet:renderURL>
		
       <liferay-ui:search-container-column-text name="Asset Title" value="${workflowDTO.assetTitle}" href="<%= rowURL %>" />
        <liferay-ui:search-container-column-text name="Asset Type" value="${workflowDTO.assetType}" href="<%= rowURL %>" />
        <liferay-ui:search-container-column-text name="Status" value="${workflowDTO.status}" href="<%= rowURL %>" />
        <liferay-ui:search-container-column-text name="Definition" value="${workflowDTO.definition}" href="<%= rowURL %>" />
        <liferay-ui:search-container-column-text name="Last Activity Date" value="${workflowDTO.lastActivityDate}" href="<%= rowURL %>" />
        <liferay-ui:search-container-column-text name="End Date" value="${workflowDTO.endDate}" href="<%= rowURL %>" />
    </liferay-ui:search-container-row>
    <liferay-ui:search-iterator />
</liferay-ui:search-container>



<%
String randomId = StringUtil.randomId();


%>



<!-- TODO -->
<% if (true == false){ %>
<liferay-ui:icon-menu
	cssClass="lfr-asset-actions"
	direction="left-side"
	icon="<%= StringPool.BLANK %>"
	markupView="lexicon"
	message="<%= StringPool.BLANK %>"
	showWhenSingleIcon="<%= true %>"
>


		<portlet:renderURL var="redirectURL">
			<portlet:param name="mvcPath" value="/view.jsp" />
			<portlet:param name="tab" value="<%= WorkflowWebKeys.WORKFLOW_TAB_INSTANCE %>" />
		</portlet:renderURL>

		<portlet:actionURL name="deleteWorkflowInstance" var="deleteURL">
			<portlet:param name="redirect" value="<%= redirectURL %>" />
			<portlet:param name="companyId" value="${workflowDTO.companyId}" />
			<portlet:param name="groupId" value="${workflowDTO.groupId}" />
			<portlet:param name="entryClassName" value="${workflowDTO.entryClassName}" />
			<portlet:param name="entryClassPK" value="${workflowDTO.assetEntryVersionId}" />
		</portlet:actionURL>

		<liferay-ui:icon
			message="withdraw-submission"
			url="<%= deleteURL %>"
		/>
</liferay-ui:icon-menu>
<% }%>