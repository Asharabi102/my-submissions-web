package com.rge.forms.workflow.submissions.dto;

import java.util.Date;

public class WorkflowDTO {

	private Long id;
	private String assetTitle;
	private String assetType;
	private String status;
	private String definition;
	private Date lastActivityDate;
	private Date endDate;
	private boolean completed;

	// asset renderer values
	private Long assetEntryId;
	private String assetRendererType;
	private Long assetEntryVersionId;
	private String entryClassName;

	private Long companyId;
	private Long groupId;

	public Long getCompanyId() {
		return companyId;
	}

	public void setCompanyId(Long companyId) {
		this.companyId = companyId;
	}

	public Long getGroupId() {
		return groupId;
	}

	public void setGroupId(Long groupId) {
		this.groupId = groupId;
	}

	public String getEntryClassName() {
		return entryClassName;
	}

	public void setEntryClassName(String entryClassName) {
		this.entryClassName = entryClassName;
	}

	public Long getAssetEntryId() {
		return assetEntryId;
	}

	public void setAssetEntryId(Long assetEntryId) {
		this.assetEntryId = assetEntryId;
	}

	public String getAssetRendererType() {
		return assetRendererType;
	}

	public void setAssetRendererType(String assetRendererType) {
		this.assetRendererType = assetRendererType;
	}

	public Long getAssetEntryVersionId() {
		return assetEntryVersionId;
	}

	public void setAssetEntryVersionId(Long assetEntryVersionId) {
		this.assetEntryVersionId = assetEntryVersionId;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getAssetTitle() {
		return assetTitle;
	}

	public void setAssetTitle(String assetTitle) {
		this.assetTitle = assetTitle;
	}

	public String getAssetType() {
		return assetType;
	}

	public void setAssetType(String assetType) {
		this.assetType = assetType;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDefinition() {
		return definition;
	}

	public void setDefinition(String definition) {
		this.definition = definition;
	}

	public Date getLastActivityDate() {
		return lastActivityDate;
	}

	public void setLastActivityDate(Date lastActivityDate) {
		this.lastActivityDate = lastActivityDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public boolean isCompleted() {
		return completed;
	}

	public void setCompleted(boolean completed) {
		this.completed = completed;
	}

	@Override
	public String toString() {
		return "WorkflowDTO [id=" + id + ", assetTitle=" + assetTitle + ", assetType=" + assetType + ", status="
				+ status + ", definition=" + definition + ", lastActivityDate=" + lastActivityDate + ", endDate="
				+ endDate + ", completed=" + completed + ", assetEntryId=" + assetEntryId + ", assetRendererType="
				+ assetRendererType + ", assetEntryVersionId=" + assetEntryVersionId + ", entryClassName="
				+ entryClassName + ", companyId=" + companyId + ", groupId=" + groupId + "]";
	}

}
