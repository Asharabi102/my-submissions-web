package com.rge.forms.workflow.submissions.portlet.actions;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.model.WorkflowInstanceLink;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCActionCommand;
import com.liferay.portal.kernel.security.auth.PrincipalException;
import com.liferay.portal.kernel.service.WorkflowInstanceLinkLocalService;
import com.liferay.portal.kernel.service.WorkflowInstanceLinkLocalServiceUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.Portal;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.liferay.portal.kernel.workflow.WorkflowException;
import com.liferay.portal.kernel.workflow.WorkflowHandler;
import com.liferay.portal.kernel.workflow.WorkflowHandlerRegistryUtil;
import com.liferay.portal.kernel.workflow.WorkflowInstance;
import com.liferay.portal.kernel.workflow.WorkflowInstanceManagerUtil;

import java.io.Serializable;
import java.util.Map;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletContext;
import javax.portlet.PortletRequestDispatcher;
import javax.portlet.PortletSession;

import org.osgi.service.component.annotations.Reference;

public class MySubmissionsActions extends BaseMVCActionCommand {

	protected void deleteWorkflowInstance(
			Map<String, Serializable> workflowContext)
		throws PortalException {

		long companyId = GetterUtil.getLong(
			workflowContext.get(WorkflowConstants.CONTEXT_COMPANY_ID));
		long groupId = GetterUtil.getLong(
			workflowContext.get(WorkflowConstants.CONTEXT_GROUP_ID));
		String className = GetterUtil.getString(
			workflowContext.get(WorkflowConstants.CONTEXT_ENTRY_CLASS_NAME));
		long classPK = GetterUtil.getLong(
			workflowContext.get(WorkflowConstants.CONTEXT_ENTRY_CLASS_PK));

		_workflowInstanceLinkLocalService.deleteWorkflowInstanceLink(
			companyId, groupId, className, classPK);
	}

	@Override
	protected void doProcessAction(
			ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {

		try {
			WorkflowInstance workflowInstance = getWorkflowInstance(
				actionRequest);

			Map<String, Serializable> workflowContext =
				workflowInstance.getWorkflowContext();

			validateUser(workflowContext);

			updateEntryStatus(workflowContext);

			deleteWorkflowInstance(workflowContext);
		}
		catch (Exception e) {
			if (e instanceof PrincipalException ||
				e instanceof WorkflowException) {

				SessionErrors.add(actionRequest, e.getClass());

				PortletSession portletSession =
					actionRequest.getPortletSession();

				PortletContext portletContext =
					portletSession.getPortletContext();

				PortletRequestDispatcher portletRequestDispatcher =
					portletContext.getRequestDispatcher("/error.jsp");

				portletRequestDispatcher.include(actionRequest, actionResponse);
			}
			else {
				throw e;
			}
		}
	}

	protected WorkflowInstance getWorkflowInstance(ActionRequest actionRequest)
		throws PortalException {
		
		Long companyId = (Long) actionRequest.getAttribute("companyId");
		Long groupId = (Long) actionRequest.getAttribute("groupId");
		String entryClassName = (String) actionRequest.getAttribute("entryClassName");
		Long entryClassPK = (Long) actionRequest.getAttribute("entryClassPK");
		
		WorkflowInstanceLink workflowInstanceLink = WorkflowInstanceLinkLocalServiceUtil
				.getWorkflowInstanceLink(companyId, groupId, entryClassName, entryClassPK);
		long workflowInstanceId = workflowInstanceLink.getWorkflowInstanceId();

		return WorkflowInstanceManagerUtil.getWorkflowInstance(companyId,
				workflowInstanceId);
	}

	protected void updateEntryStatus(Map<String, Serializable> workflowContext)
		throws PortalException {

		String className = GetterUtil.getString(
			workflowContext.get(WorkflowConstants.CONTEXT_ENTRY_CLASS_NAME));

		WorkflowHandler<?> workflowHandler =
			WorkflowHandlerRegistryUtil.getWorkflowHandler(className);

		workflowHandler.updateStatus(
			WorkflowConstants.STATUS_DRAFT, workflowContext);
	}

	protected void validateUser(Map<String, Serializable> workflowContext)
		throws PortalException {

		long companyId = GetterUtil.getLong(
			workflowContext.get(WorkflowConstants.CONTEXT_COMPANY_ID));
		long userId = GetterUtil.getLong(
			workflowContext.get(WorkflowConstants.CONTEXT_USER_ID));

		long validUserId = _portal.getValidUserId(companyId, userId);

		workflowContext.put(
			WorkflowConstants.CONTEXT_USER_ID, String.valueOf(validUserId));
	}

	@Reference
	private Portal _portal;

	@Reference
	private WorkflowInstanceLinkLocalService _workflowInstanceLinkLocalService;

}