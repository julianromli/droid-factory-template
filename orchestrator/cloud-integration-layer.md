# Cloud Integration Layer

## Overview

Phase 4 introduces a comprehensive cloud integration layer that enables the orchestrator to seamlessly utilize cloud services, manage infrastructure as code, and deploy applications to any major cloud provider. This creates a truly cloud-native development experience.

## Supported Cloud Providers

### 1. Amazon Web Services (AWS)
```typescript
class AWSIntegration {
  private clients: {
    ec2: EC2Client;
    ecs: ECSClient;
    eks: EKSClient;
    lambda: LambdaClient;
    rds: RDSClient;
    s3: S3Client;
    cloudwatch: CloudWatchClient;
    route53: Route53Client;
    elasticbeanstalk: ElasticBeanstalkClient;
    lightsail: LightsailClient;
  };
  
  private resourceManager: AWSResourceManager;
  private costOptimizer: AWSCostOptimizer;
  private securityManager: AWSSecurityManager;
  
  async provisionCompleteStack(
    stackDefinition: AWSStackDefinition
  ): Promise<ProvisionedStack> {
    
    console.log(`Provisioning AWS stack: ${stackDefinition.name}`);
    
    const provisioned = {
      infrastructure: {},
      services: {},
      security: {},
      networking: {},
      monitoring: {}
    };
    
    // 1. Provision Networking Layer
    provisioned.networking = await this.provisionNetworkLayer(stackDefinition.networking);
    
    // 2. Provision Database Layer
    if (stackDefinition.database) {
      provisioned.database = await this.provisionDatabaseLayer(stackDefinition.database);
    }
    
    // 3. Provision Application Layer
    if (stackDefinition.application) {
      provisioned.application = await this.provisionApplicationLayer(stackDefinition.application);
    }
    
    // 4. Setup Security
    provisioned.security = await this.setupSecurity(stackDefinition.security);
    
    // 5. Setup Monitoring
    provisioned.monitoring = await this.setupMonitoring(stackDefinition.monitoring);
    
    // 6. Configure Auto Scaling
    if (stackDefinition.autoScaling) {
      await this.configureAutoScaling(provisioned, stackDefinition.autoScaling);
    }
    
    // 7. Create CloudFormation Outputs
    const outputs = await this.generateStackOutputs(provisioned);
    
    return {
      stack_id: this.generateStackId(),
      stack_name: stackDefinition.name,
      region: stackDefinition.region,
      provisioned_resources: provisioned,
      outputs: outputs,
      total_monthly_cost: this.calculateMonthlyCost(provisioned),
      creation_time: new Date(),
      status: "active"
    };
  }
  
  private async provisionApplicationLayer(
    appConfig: ApplicationConfig
  ): Promise<ProvisionedApplication> {
    
    const application = {
      frontend: null,
      backend: null,
      api_gateway: null,
      load_balancer: null
    };
    
    // Frontend (S3 + CloudFront + Next.js)
    if (appConfig.frontend) {
      application.frontend = await this.provisionNextJSApp(appConfig.frontend);
    }
    
    // Backend (Fargate + Node.js)
    if (appConfig.backend) {
      application.backend = await this.provisionNodeJSService(appConfig.backend);
    }
    
    // API Gateway
    if (appConfig.api_gateway) {
      application.api_gateway = await this.provisionAPIGateway(appConfig.api_gateway);
    }
    
    // Load Balancer
    if (appConfig.load_balancer) {
      application.load_balancer = await this.provisionLoadBalancer(appConfig.load_balancer);
    }
    
    return application;
  }
  
  private async provisionNextJSApp(
    frontendConfig: FrontendConfig
  ): Promise<ProvisionedFrontend> {
    
    // S3 Bucket for static assets
    const bucket = await this.s3.createBucket({
      Bucket: frontendConfig.domain_name,
      CreateBucketConfiguration: {
        LocationConstraint: {
          LocationConstraint: frontendConfig.region
        },
        PublicAccessBlockConfiguration: {
          BlockPublicAcls: false,
          BlockPublicPolicy: false
        }
      }
    });
    
    // CloudFront Distribution
    const distribution = await this.cloudfront.createDistribution({
      DistributionConfig: {
        Origins: [
          {
            Id: "S3-" + frontendConfig.domain_name,
            DomainName: `${frontendConfig.domain_name}.s3.amazonaws.com`,
            S3OriginConfig: {
              OriginAccessIdentityId: this.originAccessIdentity
            }
          }
        ],
        DefaultCacheBehavior: {
          TargetOriginId: "S3-" + frontendConfig.domain_name,
          ViewerProtocolPolicy: "redirect-to-https",
          AllowedMethods: ["GET", "HEAD", "OPTIONS"],
          CachedMethods: ["GET", "HEAD", "OPTIONS"],
          ForwardedValues: {
            QueryString: true,
            Cookies: true
          },
          MinTTL: frontendConfig.cache_config.min_ttl,
          DefaultTTL: frontendConfig.cache_config.default_ttl,
          MaxTTL: frontendConfig.cache_config.max_ttl
        },
        ViewerCertificate: frontendConfig.ssl_certificate,
        PriceClass: frontendConfig.price_class || "PriceClass_100",
        Enabled: true
      }
    });
    
    // Build and Deploy Next.js App
    const buildResult = await this.buildAndDeployNextJS(
      frontendConfig,
      bucket.Location!,
      distribution.Id!
    );
    
    return {
      bucket_name: bucket.Name!,
      distribution_id: distribution.Id!,
      domain_name: frontendConfig.domain_name,
      build_artifacts: buildResult.artifacts,
      cdn_url: distribution.DomainName,
      ssl_arn: distribution.ETag!,
      status: "active"
    };
  }
}
```

### 2. Google Cloud Platform (GCP)
```typescript
class GCPIntegration {
  private clients: {
    compute: ComputeClient;
    container: ContainerClient;
    cloud_run: CloudRunClient;
    app_engine: AppEngineClient;
    bigquery: BigQueryClient;
    storage: StorageClient;
    dns: DNSClient;
    monitoring: MonitoringClient;
  };
  
  async provisionCompletePlatform(
    platformConfig: GCPPlatformConfig
  ): Promise<ProvisionedPlatform> {
    
    console.log(`Provisioning GCP platform: ${platformConfig.name}`);
    
    const provisioned = {
      infrastructure: {},
      applications: {},
      databases: {},
      networking: {},
      monitoring: {}
    };
    
    // 1. Setup Project and Permissions
    await this.setupProjectAndPermissions(platformConfig);
    
    // 2. Provision Networking
    provisioned.networking = await this.provisionGCPNetworking(platformConfig.networking);
    
    // 3. Provision Databases
    if (platformConfig.databases) {
      provisioned.databases = await this.provisionGCPDatabases(platformConfig.databases);
    }
    
    // 4. Deploy Applications
    if (platformConfig.applications) {
      provisioned.applications = await this.deployGCPApplications(platformConfig.applications);
    }
    
    // 5. Setup Monitoring and Logging
    provisioned.monitoring = await this.setupGCPMonitoring(provisioned);
    
    // 6. Configure IAM
    await this.configureGCPIAM(provisioned);
    
    return {
      project_id: platformConfig.project_id,
      platform_name: platformConfig.name,
      provisioned_resources: provisioned,
      service_accounts: provisioned.service_accounts,
      monitoring: provisioned.monitoring,
      estimated_monthly_cost: this.calculateMonthlyCost(provisioned),
      creation_time: new Date()
    };
  }
  
  private async deployGCPApplications(
    apps: GCPApplication[]
  ): Promise<ProvisionedGCPApplications> {
    
    const deployed = {
      cloud_run_services: [],
      app_engine_apps: [],
      compute_instances: []
    };
    
    for (const app of apps) {
      switch (app.type) {
        case "cloud_run":
          const service = await this.cloud_run.createService({
            name: app.name,
            template: {
              spec: {
                serviceAccount: app.service_account,
                template: {
                  spec: {
                    containers: [
                      {
                        image: app.image,
                        resources: app.resource_requirements,
                        env: app.environment_variables
                      }
                    ],
                    scaling: app.scaling,
                    timeout_seconds: app.timeout_seconds
                  }
                }
              }
            }
          });
          
          deployed.cloud_run_services.push({
            name: service.name,
            url: service.status.url,
            scaling: service.template.spec.scaling,
            service_account: service.spec.template.spec.serviceAccount
          });
          break;
          
        case "app_engine":
          const appEngineApp = await this.app_engine.createApplication({
            name: app.name,
            location: app.region,
            runtime: app.runtime,
            deployment: {
              resources: app.resource_requirements,
              env: app.environment_variables
            }
          });
          
          deployed.app_engine_apps.push({
            name: appEngineApp.name,
            url: appEngineApp.defaultHostname,
            region: appEngineApp.location,
            runtime: appEngineApp.runtime
          });
          break;
          
        case "compute_engine":
          const instance = await this.compute.createInstance({
            name: app.name,
            zone: app.zone,
            machineType: app.machine_type,
            image: app.image,
            networkInterfaces: app.network_interfaces,
            metadata: app.metadata
          });
          
          deployed.compute_instances.push({
            name: instance.name,
            zone: instance.zone,
            machine_type: instance.machineType,
            external_ip: instance.networkInterfaces?.[0]?.accessConfigs?.[0]?.natIP,
            status: instance.status
          });
          break;
      }
    }
    
    return deployed;
  }
}
```

### 3. Microsoft Azure
```typescript
class AzureIntegration {
  private clients: {
    compute: ComputeManagementClient;
    containerService: ContainerServiceManagementClient;
    appService: WebSiteManagementClient;
    functions: FunctionsClient;
    storage: StorageManagementClient;
    sql: SqlManagementClient;
    keyVault: KeyVaultClient;
    monitor: MonitorManagementClient;
  };
  
  async provisionCompleteAzureStack(
    stackConfig: AzureStackConfig
  ): Promise<ProvisionedAzureStack> {
    
    console.log(`Provisioning Azure stack: ${stackConfig.name}`);
    
    const provisioned = {
      resource_group: null,
      infrastructure: {},
      applications: {},
      databases: {},
      networking: {},
      security: {},
      monitoring: {}
    };
    
    // 1. Create Resource Group
    provisioned.resource_group = await this.createResourceGroup(stackConfig.resource_group);
    
    // 2. Provision Networking
    provisioned.networking = await this.provisionAzureNetworking(stackConfig.networking);
    
    // 3. Provision Databases
    if (stackConfig.databases) {
      provisioned.databases = await this.provisionAzureDatabases(stackConfig.databases);
    }
    
    // 4. Deploy Applications
    if (stackConfig.applications) {
      provisioned.applications = await this.deployAzureApplications(stackConfig.applications);
    }
    
    // 5. Setup Security
    provisioned.security = await this.setupAzureSecurity(provisioned);
    
    // 6. Setup Monitoring
    provisioned.monitoring = await this.setupAzureMonitoring(provisioned);
    
    return {
      resource_group: provisioned.resource_group.name,
      stack_name: stackConfig.name,
      subscription_id: stackConfig.subscription_id,
      location: stackConfig.location,
      provisioned_resources: provisioned,
      estimated_monthly_cost: this.calculateMonthlyCost(provisioned),
      creation_time: new Date()
    };
  }
  
  private async deployAzureApplications(
    apps: AzureApplication[]
  ): Promise<ProvisionedAzureApplications> {
    
    const deployed = {
      app_services: [],
      container_instances: [],
      function_apps: [],
      static_sites: []
    };
    
    for (const app of apps) {
      switch (app.type) {
        case "app_service":
          const appService = await this.app_service.createAppService({
            name: app.name,
            resourceGroupName: app.resource_group,
            location: app.location,
            appServicePlan: app.app_service_plan,
            container_settings: app.container_settings,
            app_settings: app.app_settings,
            custom_domains: app.custom_domains
          });
          
          deployed.app_services.push({
            name: appService.name,
            url: appService.defaultHostName,
            status: appService.state,
            plan: appService.appServicePlan
          });
          break;
          
        case "static_site":
          const staticSite = await this.app_service.createStaticSite({
            name: app.name,
            resourceGroupName: app.resource_group,
            location: app.location,
            sku: app.sku,
            custom_domains: app.custom_domains
          });
          
          deployed.static_sites.push({
            name: staticSite.name,
            url: staticSite.defaultHostName,
            status: staticSite.state,
            sku: staticSite.sku
          });
          break;
          
        case "function_app":
          const functionApp = await this.functions.createFunctionApp({
            name: app.name,
            resourceGroupName: app.resource_group,
            location: app.location,
            storageAccount: app.storage_account,
            appInsightsKey: app.app_insights_key
          });
          
          deployed.function_apps.push({
            name: functionApp.name,
            status: functionApp.state,
            default_hostname: functionApp.defaultHostname
          });
          break;
      }
    }
    
    return deployed;
  }
}
```

## Infrastructure as Code (IaC)

### Terraform Integration
```typescript
class TerraformIntegration {
  private terraformClient: TerraformClient;
  private templateBuilder: TerraformTemplateBuilder;
  
  async provisionInfrastructureAsCode(
    terraformConfig: TerraformConfig
  ): Promise<IaCProvisioningResult> {
    
    console.log(`Provisioning infrastructure with Terraform: ${terraformConfig.project_name}`);
    
    // 1. Generate Terraform templates
    const templates = await this.templateBuilder.generateTemplates(terraformConfig);
    
    // 2. Initialize Terraform workspace
    const workspaceResult = await this.terraformClient.init({
      backend: terraformConfig.backend_config,
      workspace: terraformConfig.workspace_name
    });
    
    // 3. Plan infrastructure
    const planResult = await this.terraformClient.plan({
      plan_path: terraformConfig.plan_path,
      var_file: terraformConfig.var_file,
      state_file: terraform_config.state_file
    });
    
    // 4. Apply infrastructure
    const applyResult = await this.terraformClient.apply({
      plan_path: terraformConfig.plan_path,
      var_file: terraformConfig.var_file,
      state_file: terraform_config.state_file,
      auto_approve: terraformConfig.auto_approve
    });
    
    // 5. Validate deployment
    const validation = await this.validateDeployment(applyResult);
    
    return {
      terraform_project: terraformConfig.project_name,
      workspace: workspaceResult,
      plan_summary: planResult.summary,
      apply_summary: applyResult.summary,
      validation: validation,
      created_resources: applyResult.outputs,
      state_file: terraform_config.state_file,
      template_files: templates
    };
  }
  
  private async generateTemplates(
    config: TerraformConfig
  ): Promise<TerraformTemplate[]> {
    
    const templates: TerraformTemplate[] = [];
    
    // Main template
    templates.push({
      filename: "main.tf",
      content: this.generateMainTerraformTemplate(config)
    });
    
    // Networking templates
    if (config.networking) {
      templates.push({
        filename: "networking.tf",
        content: this.generateNetworkingTemplate(config.networking)
      });
    }
    
    // Database templates
    if (config.databases) {
      templates.push({
        filename: "databases.tf",
        content: this.generateDatabaseTemplate(config.databases)
      });
    }
    
    // Application templates
    if (config.applications) {
      templates.push({
        filename: "applications.tf",
        content: this.generateApplicationTemplate(config.applications)
      });
    }
    
    // Security templates
    if (config.security) {
      templates.push({
        filename: "security.tf",
        content: this.generateSecurityTemplate(config.security)
      });
    }
    
    // Monitoring templates
    if (config.monitoring) {
      templates.push({
        filename: "monitoring.tf",
        content: this.generateMonitoringTemplate(config.monitoring)
      });
    }
    
    return templates;
  }
}
```

### Pulumi Integration
```typescript
class PulumiIntegration {
  private pulumi: PulumiAutomation;
  
  async deployWithPulumi(
    stackConfig: PulumiStackConfig
  ): Promise<PulumiDeployment> {
    
    const pulumiProgram = await this.generatePulumiProgram(stackConfig);
    
    const stack = await pulumiProgram.stack(stackConfig.stackName, {
      program: pulumiProgram,
      opts: {
        stackName: stackConfig.stack_name,
        region: stackConfig.region,
        project: stackConfig.project_name
      }
    });
    
    const result = await stack.outputs.apply();
    
    return {
      stack_name: stackConfig.stack_name,
      outputs: result.outputs,
      resources: result.resources,
      summary: stack.summary,
      duration_ms: result.durationMs
    };
  }
}
```

## Cloud Service Integration

### 1. Database as a Service (DBaaS)
```typescript
class DatabaseAsAService {
  private awsRDS: RDSClient;
  private gcpSpanner: SpannerClient;
  private azureSQL: SqlManagementClient;
  
  async provisionDatabase(
    databaseConfig: DatabaseConfig
  ): Promise<ProvisionedDatabase> {
    
    const cloudProvider = databaseConfig.cloud_provider.toLowerCase();
    
    switch (cloudProvider) {
      case "aws":
        return await this.provisionAWSRDS(databaseConfig);
      case "gcp":
        return await this.provisionGCPSpanner(databaseConfig);
      case "azure":
        return await this.provisionAzureSQL(databaseConfig);
      default:
        throw new Error(`Unsupported cloud provider: ${cloudProvider}`);
    }
  }
  
  private async provisionAWSRDS(
    config: DatabaseConfig
  ): Promise<ProvisionedDatabase> {
    
    const parameterGroup = await this.awsRDS.createDBParameterGroup({
      DBParameterGroupName: `${config.name}-params`,
      Description: `Parameter group for ${config.name}`,
      Family: config.database_family,
      Parameters: config.parameters
    });
    
    const subnetGroup = await this.awsRDS.createDBSubnetGroup({
      DBSubnetGroupName: `${config.name}-subnet`,
      Description: `Subnet group for ${config.name}`,
      SubnetIds: config.subnet_ids
    });
    
    const instance = await this.awsRDS.createDBInstance({
      DBName: config.name,
      DBInstanceIdentifier: config.identifier,
      DBInstanceClass: config.instance_class,
      Engine: config.engine,
      EngineVersion: config.engine_version,
      MasterUsername: config.username,
      MasterUserPassword: config.password,
      AllocatedStorage: config.storage_gb,
      DBInstanceClass = config.instance_class,
      DBParameterGroupName: parameterGroup.DBParameterGroupName,
      DBSubnetGroupName: subnetGroup.DBSubnetGroupName,
      VpcSecurityGroupIds: config.security_group_ids,
      BackupRetentionPeriod: config.backup_retention_days,
      MultiAZ: config.multi_az,
      PubliclyAccessible: config.publicly_accessible,
      StorageType: config.storage_type,
      StorageEncrypted: config.encrypted
    });
    
    return {
      database_id: instance.DBInstanceIdentifier!,
      database_name: instance.DBName!,
      endpoint: instance.Endpoint?.Address!,
      port: instance.Endpoint?.Port!,
      username: instance.MasterUsername!,
      status: instance.DBInstanceStatus!,
      creation_time: instance.InstanceCreateTime,
      backup_retention: instance.BackupRetentionPeriod,
      encrypted: instance.StorageEncrypted
    };
  }
}
```

### 2. Message Queue Services
```typescript
class MessageQueueIntegration {
  private awsSQS: SQSClient;
  private gcpPubSub: PubSubClient;
  private azureServiceBus: ServiceBusClient;
  
  async provisionMessageQueue(
    queueConfig: MessageQueueConfig
  ): Promise<ProvisionedQueue> {
    
    const cloudProvider = queueConfig.cloud_provider.toLowerCase();
    
    switch (cloudProvider) {
      case "aws":
        return await this.provisionSQSQueue(queueConfig);
      case "gcp":
        return await this.provisionPubSubTopic(queueConfig);
      case "azure":
        return await this.provisionServiceBusQueue(queueConfig);
      default:
        throw new Error(`Unsupported cloud provider: ${cloudProvider}`);
    }
  }
  
  private async provisionSQSQueue(
    config: MessageQueueConfig
  ): Promise<Queue> {
    
    const queue = await this.awsSQS.createQueue({
      QueueName: config.name,
      Attributes: {
        DelaySeconds: config.delay_seconds,
        MessageRetentionPeriod: config.retention_seconds,
        VisibilityTimeout: config.visibility_timeout_seconds,
        MaximumMessageSize: config.max_message_size
      }
    });
      ;
      
      return {
        queue_url: queue.QueueUrl!,
        queue_arn: queue.QueueArn!,
        queue_name: config.name,
        region: this.extractRegion(queue.QueueArn!),
        visibility_timeout: config.visibility_timeout_seconds,
        message_retention: config.retention_seconds,
        max_message_size: config.max_message_size
      };
    }
}
```

### 3. Object Storage Services
```typescript
class ObjectStorageIntegration {
  private awsS3: S3Client;
  private gcpGCS: StorageClient;
  private azureBlob: BlobServiceClient;
  
  async provisionStorageBucket(
    storageConfig: StorageConfig
  ): Promise<ProvisionedStorage> {
    
    const cloudProvider = storageConfig.cloud_provider.toLowerCase();
    
    switch (cloudProvider) {
      case "aws":
        return await this.provisionS3Bucket(storageConfig);
      case "gcp":
        return await this.provisionGCSBucket(storageConfig);
      case "azure":
        return await this.provisionAzureBlobStorage(storageConfig);
      default:
        throw new Error(`Unsupported cloud provider: ${cloudProvider}`);
    }
  }
  
  private async provisionS3Bucket(
    config: StorageConfig
  ): Promise<ProvisionedStorage> {
    
    const bucket = await this.awsS3.createBucket({
      Bucket: config.bucket_name,
      CreateBucketConfiguration: {
        LocationConstraint: {
          LocationConstraint: config.region
        },
        PublicAccessBlockConfiguration: {
          BlockPublicAcls: config.private ? 
            [true] : [false],
          BlockPublicPolicy: config.private ? 
            [true] : [false]
        }
      }
    });
    
    // Add lifecycle rules
    if (config.lifecycle_rules) {
      await this.addS3LifecycleRules(bucket.Name!, config.lifecycle_rules);
    }
    
    // Add CORS configuration if needed
    if (config.cors_config) {
      await this.addS3CORS(bucket.Name!, config.cors_config);
    }
    
    return {
      bucket_name: bucket.Name!,
      region: this.extractRegion(bucket.Location!),
      arn: bucket.Arn!,
      endpoint: this.generateS3Endpoint(bucket.Name!, config.region),
      private: config.private,
      versioning: config.versioning_enabled,
      lifecycle_rules: config.lifecycle_rules
    };
  }
}
```

## Cost Optimization

### Cloud Cost Optimizer
```typescript
class CloudCostOptimizer {
  private awsPricing: AWSPricingService;
  private gcpPricing: GCPPricingService;
  private azurePricing: AzurePricingService;
  
  async optimizeForCost(
    deploymentRequirements: DeploymentRequirements,
    budget: BudgetConstraints
  ): Promise<CostOptimization> {
    
    const optimizations = [];
    
    // Get pricing from all providers
    const pricing = await this.getAllPricing();
    
    // Analyze cost per region
    const regionalCosts = this.analyzeRegionalCosts(pricing, deploymentRequirements);
    
    // Find most cost-effective combination
    const optimalSolution = this.findOptimalSolution(
      deploymentRequirements,
      budget,
      regionalCosts
    );
    
    // Generate cost optimization recommendations
    const recommendations = this.generateCostRecommendations(
      optimalSolution,
      budget,
      pricing
    );
    
    return {
      recommended_solution: optimalSolution,
      estimated_monthly_cost: optimalSolution.monthly_cost,
      budget_utilization: (optimalSolution.monthly_cost / budget.max_monthly_cost) * 100,
      recommendations: recommendations,
      potential_savings: this.calculatePotentialSavings(optimalSolution, regionalCosts)
    };
  }
  
  private findOptimalSolution(
    requirements: DeploymentRequirements,
    budget: BudgetConstraints,
    regionalCosts: RegionalCosts
  ): OptimalSolution {
    
    const solutions = [];
    
    // Generate all possible combinations
    const regions = Object.keys(regionalCosts);
    
    for (const region of regions) {
      for (const instanceType of this.getInstanceTypes(requirements)) {
        const cost = this.calculateRegionalCost(
          region,
          instanceType,
          requirements
        );
        
        if (cost <= budget.max_monthly_cost) {
          solutions.push({
            region,
            instance_type: instanceType,
            cost_per_month: cost,
            performance_score: this.calculatePerformanceScore(instanceType, requirements),
            reliability_score: this.calculateReliabilityScore(region, instanceType)
          });
        }
      }
    }
    
    // Sort by value score (performance/cost ratio)
    return solutions.sort((a, b) => b.value_score - a.value_score)[0];
  }
}
```

## Security Integration

### Cloud Security Manager
```typescript
class CloudSecurityManager {
  private awsSecurity: AWSSecurityManager;
  private gcpSecurity: GCPSecurityManager;
  private azureSecurity: AzureSecurityManager;
  
  async setupSecurity(
    securityConfig: SecurityConfig
  ): Promise<SecuritySetup> {
    
    const security = {
      iam: {},
      network: {},
      data: {},
      compliance: {}
    };
    
    const cloudProvider = securityConfig.cloud_provider.toLowerCase();
    
    switch (cloud) {
      case "aws":
        security.iam = await this.setupAWSIAM(securityConfig.iam);
        security.network = await this.setupAWSNetworkSecurity(securityConfig.network);
        security.data = await this.setupAWSDataSecurity(securityConfig.data);
        security.compliance = await this.setupAWSCompliance(securityConfig.compliance);
        break;
        
      case "gcp":
        security.iam = await this.setupGCP_IAM(securityConfig.iam);
        security.network = await this.setupGCPNetworkSecurity(securityConfig.network);
        security.data = await this.setupGCPDataSecurity(securityConfig.data);
        security.compliance = await this.setupGCPCompliance(securityConfig.compliance);
        break;
        
      case "azure":
        security.iam = await this.setupAzureIAM(securityConfig.iam);
        security.network = await this.setupAzureNetworkSecurity(securityConfig.network);
        security.data = await this.setupAzureDataSecurity(securityConfig.data);
        security.compliance = await this.setupAzureCompliance(securityConfig.compliance);
        break;
    }
    
    return security;
  }
  
  private async setupAWSIAM(iamConfig: IAMConfig): Promise<AWSIAM> {
    
    // Create IAM role for orchestrator
    const orchestratorRole = await this.awsSecurity.createRole({
      RoleName: `${iamConfig.project_name}-orchestrator-role`,
      Description: "Role for Factory CLI Orchestrator",
      AssumeRolePolicyDocument: this.generateTrustPolicy(),
      Policies: [
        {
          PolicyName: `${iamConfig.project_name}-orchestrator-access`,
          PolicyDocument: this.generateOrchestratorPolicy(iamConfig)
        }
      ]
    });
    
    // Create IAM user if needed
    const user = iamConfig.create_user ? 
      await this.awsSecurity.createUser(iamConfig.user) : null;
    
    return {
      role_arn: orchestratorRole.Role.Arn,
      user_name: user?.User?.UserName || null,
      trust_policy: orchestratorRole.AssumeRolePolicyDocument,
      policies: orchestratorRole.Policies,
      credentials: await this.generateTemporaryCredentials(orchestratorRole)
    };
  }
}
```

---

This cloud integration layer provides native cloud service integration for the Factory CLI orchestrator, enabling true cloud-native development! ☁️☁️☁️✨
