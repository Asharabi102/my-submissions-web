package com.rge.forms.workflow.submissions.portlet;

import com.liferay.asset.kernel.model.AssetEntry;
import com.liferay.asset.kernel.model.AssetRenderer;
import com.liferay.asset.kernel.model.AssetRendererFactory;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.kernel.workflow.WorkflowHandler;
import com.liferay.portal.kernel.workflow.WorkflowHandlerRegistryUtil;
import com.liferay.portal.workflow.kaleo.model.KaleoInstance;
import com.liferay.portal.workflow.kaleo.model.KaleoInstanceToken;
import com.liferay.portal.workflow.kaleo.service.KaleoInstanceLocalServiceUtil;
import com.liferay.portal.workflow.kaleo.service.KaleoInstanceTokenLocalServiceUtil;
import com.rge.forms.workflow.submissions.constants.MySubmissionsWebPortletKeys;
import com.rge.forms.workflow.submissions.dto.WorkflowDTO;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;

/**
 * @author ashar
 */
@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=MySubmissionsWeb",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + MySubmissionsWebPortletKeys.MYSUBMISSIONSWEB,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class MySubmissionsWebPortlet extends MVCPortlet {
	@Override
	public void render(RenderRequest renderRequest, RenderResponse renderResponse)
			throws IOException, PortletException {

		ThemeDisplay themeDisplay = (ThemeDisplay) renderRequest.getAttribute(WebKeys.THEME_DISPLAY);
		Locale locale = themeDisplay.getLocale();
		Long userId = themeDisplay.getUserId();
		Long groupId = themeDisplay.getScopeGroupId();
		Long companyId = themeDisplay.getCompanyId();

		List<Long> kaleoInstanceIdsList = getKaleoInstanceIds(userId);

		List<WorkflowDTO> workflowDTOList = new ArrayList<>();
		KaleoInstance kaleoInstance = null;
		KaleoInstanceToken kaleoInstanceToken = null;

		for (Long kaleoInstanceId : kaleoInstanceIdsList) {
			try {

				kaleoInstance = KaleoInstanceLocalServiceUtil.getKaleoInstance(kaleoInstanceId);

				if (Validator.isNotNull(kaleoInstance)) {

					kaleoInstanceToken = getKaleoInstanceToken(kaleoInstanceId);
					String entryClassName = kaleoInstance.getClassName();
					WorkflowHandler<?> workflowHandler = WorkflowHandlerRegistryUtil.getWorkflowHandler(entryClassName);

					// getting assetEntryId & assetRendererType & entryClassPK
					Long entryClassPK = kaleoInstance.getClassPK();

					AssetRenderer<?> assetRenderer = workflowHandler.getAssetRenderer(entryClassPK);
					String assetRendererType = assetRenderer.getAssetRendererFactory().getType();
					AssetRendererFactory<?> assetRendererFactory = assetRenderer.getAssetRendererFactory();
					AssetEntry assetEntry = assetRendererFactory.getAssetEntry(assetRenderer.getClassName(),
							assetRenderer.getClassPK());
					long assetEntryId = assetEntry.getPrimaryKey();

					// getting workflowDTO values
					long id = kaleoInstance.getKaleoInstanceId();
					String assetTitle = workflowHandler.getTitle(entryClassPK, locale);
					String assetType = workflowHandler.getType(locale);
					String definition = kaleoInstance.getKaleoDefinitionName();
					boolean completed = kaleoInstance.getCompleted();
					String status = kaleoInstanceToken.getCurrentKaleoNodeName();
					Date lastActivityDate = kaleoInstance.getModifiedDate();
					Date endDate = kaleoInstance.getCompletionDate();

					WorkflowDTO workflowDTO = new WorkflowDTO();
					workflowDTO.setId(id);
					workflowDTO.setAssetTitle(assetTitle);
					workflowDTO.setAssetType(assetType);
					workflowDTO.setDefinition(definition);
					workflowDTO.setCompleted(completed);
					workflowDTO.setStatus(status);
					workflowDTO.setLastActivityDate(lastActivityDate);
					workflowDTO.setEndDate(endDate);

					// asset renderer values
					workflowDTO.setAssetEntryId(assetEntryId);
					workflowDTO.setAssetRendererType(assetRendererType);
					workflowDTO.setAssetEntryVersionId(entryClassPK);
					workflowDTO.setEntryClassName(entryClassName);
					
					//workflowInstanceLink values
					workflowDTO.setCompanyId(companyId);
					workflowDTO.setGroupId(groupId);

					System.out.println(workflowDTO.toString());

					workflowDTOList.add(workflowDTO);

					// if we need workflowcontext ...

					/*
					 * WorkflowInstanceLink workflowInstanceLink =
					 * WorkflowInstanceLinkLocalServiceUtil .getWorkflowInstanceLink(companyId,
					 * groupId, entryClassName, entryClassPK); long workflowInstanceId =
					 * workflowInstanceLink.getWorkflowInstanceId(); WorkflowInstance
					 * workflowInstance = WorkflowInstanceManagerUtil.getWorkflowInstance(companyId,
					 * workflowInstanceId); Map<String, Serializable> workflowContext =
					 * workflowInstance.getWorkflowContext(); long assetEntryClassPK = GetterUtil
					 * .getLong((String)
					 * workflowContext.get(WorkflowConstants.CONTEXT_ENTRY_CLASS_PK)); long
					 * assetEntryVersionId = assetEntryClassPK;
					 */

					// renderRequest.setAttribute("assetEntryId", assetEntryId);
					// renderRequest.setAttribute("assetRendererType", assetRendererType);
					// renderRequest.setAttribute("assetEntryVersionId", entryClassPK);

				}
			} catch (PortalException e) {
				e.printStackTrace();
			}

		}

		renderRequest.setAttribute("workflowDTOList", workflowDTOList);

		super.render(renderRequest, renderResponse);
	}

	public List<Long> getKaleoInstanceIds(Long userId) {
		DynamicQuery kaleoInstanceQuery = KaleoInstanceLocalServiceUtil.dynamicQuery();
		kaleoInstanceQuery.setProjection(PropertyFactoryUtil.forName("kaleoInstanceId"));
		kaleoInstanceQuery.add(RestrictionsFactoryUtil.eq("userId", userId));

		return KaleoInstanceLocalServiceUtil.dynamicQuery(kaleoInstanceQuery);
	}

	public KaleoInstanceToken getKaleoInstanceToken(Long kaleoInstanceId) {
		DynamicQuery kaleoInstanceTokenQuery = KaleoInstanceTokenLocalServiceUtil.dynamicQuery();
		kaleoInstanceTokenQuery.setProjection(PropertyFactoryUtil.forName("kaleoInstanceTokenId"));
		kaleoInstanceTokenQuery.add(RestrictionsFactoryUtil.eq("kaleoInstanceId", kaleoInstanceId));
		List<Long> kaleoInstanceTokenIdsList = KaleoInstanceTokenLocalServiceUtil.dynamicQuery(kaleoInstanceTokenQuery);
		Long kaleoInstanceTokenId = kaleoInstanceTokenIdsList.get(0);
		try {
			return KaleoInstanceTokenLocalServiceUtil.getKaleoInstanceToken(kaleoInstanceTokenId);
		} catch (PortalException e) {
			e.printStackTrace();
		}
		return null;
	}

	
}