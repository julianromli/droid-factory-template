# Droid-to-Droid Communication Protocol

## Overview

Phase 3 introduces direct communication between droids during orchestration, enabling real-time collaboration, knowledge sharing, and dynamic coordination beyond the traditional sequential model.

## Communication Architecture

### Communication Channels

#### 1. Orchestrator-Mediated Communication
```
Droid A → Orchestrator → Droid B
- Most common and safest approach
- Orchestrator validates and routes messages
- Full logging and conflict detection
- Context preservation guaranteed
```

#### 2. Direct Droid Communication
```
Droid A → Droid B (via orchestrator bus)
- For urgent clarifications during parallel execution
- Orchestrator still monitors but doesn't interfere
- Faster response times
- Risk management by orchestrator
```

#### 3. Broadcast Communication
```
Droid → All Active Droids
- Important announcements affecting multiple droids
- System-wide changes or critical discoveries
- Orchestrator ensures delivery
```

### Message Types

#### 1. Query Messages
```typescript
interface QueryMessage {
  type: "query";
  from_droid: string;
  to_droid: string;
  urgency: "low" | "medium" | "high" | "critical";
  query: string;
  context?: any;
  expected_response_time?: number; // minutes
  metadata?: {
    phase_id: string;
    task_id: string;
    correlation_id: string;
  };
}
```

#### 2. Response Messages
```typescript
interface ResponseMessage {
  type: "response";
  from_droid: string;
  to_droid: string;
  correlation_id: string;
  response: string | object;
  action_required?: boolean;
  metadata?: {
    response_time: number;
    confidence: number;
  };
}
```

#### 3. Coordination Messages
```typescript
interface CoordinationMessage {
  type: "coordination";
  from_droid: string;
  to_droid?: string; // null for broadcast
  coordination_type: "dependency" | "blocker" | "discovery" | "recommendation";
  content: {
    action: string;
    impact: string;
    timeline?: string;
    requirements?: string[];
  };
  priority: "low" | "medium" | "high" | "critical";
}
```

#### 4. Discovery Messages
```typescript
interface DiscoveryMessage {
  type: "discovery";
  from_droid: string;
  discovery_type: "api_endpoint" | "component" | "dependency" | "conflict";
  content: {
    discovered: string;
    location: string;
    impact: string;
    recommended_action?: string;
  };
  broadcast_to: string[]; // List of interested droids
}
```

## Communication Use Cases

### Use Case 1: Parallel Implementation Coordination

**Scenario**: Frontend and backend droids working in parallel need to align on API contracts.

**Traditional Approach**:
```
Phase 1: Backend designs API
Phase 2: Frontend implements based on design
```

**Enhanced Approach with Communication**:
```
Phase 1: Backend starts API design
Phase 1.5: Frontend starts UI mockups in parallel
Communication:
  Frontend → Backend: "Need user profile structure for avatar upload"
  Backend → Frontend: "User object includes avatar_url, avatar_size, avatar_type"
  Frontend → Backend: "Can we add avatar metadata fields?"
  Backend → Frontend: "Yes, adding avatar_metadata JSON field"
Result: Both work together in real-time
```

### Use Case 2: Cross-Phase Dependency Discovery

**Scenario**: Security droid discovers requirement that affects current implementation.

**Traditional Approach**:
```
Security droid waits until next phase to communicate
```

**Enhanced Approach**:
```
Security droid (during review phase) → Backend droid (still implementing):
  "CRITICAL: Password hashing algorithm needs upgrade to bcrypt"
Backend droid response: "Implementing bcrypt now, will add migration"
Result: Real-time fix without phase delay
```

### Use Case 3: Performance Optimization Collaboration

**Scenario**: Performance engineer discovers bottleneck during testing.

**Traditional Approach**:
```
Performance engineer waits for review phase
```

**Enhanced Approach**:
```
Performance engineer → All droids:
  "Database query taking 3s, need caching strategy"
Database admin response: "Adding Redis cache layer"
Backend engineer response: "Implementing cache in API layer"
Result: Immediate performance optimization
```

## Implementation Protocol

### Message Sending

#### From Droid Perspective
```typescript
// Droid can send messages using the orchestrator
function sendMessage(message: Message): Promise<Response> {
  return orchestrator.sendMessage(message);
}

// Example: Frontend developer needs API clarification
await orchestrator.sendMessage({
  type: "query",
  from_droid: "frontend-developer",
  to_droid: "backend-architect",
  urgency: "high",
  query: "What data structure should I expect for user profile API response?",
  context: {
    current_component: "UserProfile.tsx",
    implementing_feature: "user_profile_display"
  }
});
```

#### Orchestrator Message Routing
```typescript
class MessageRouter {
  async routeMessage(message: Message): Promise<void> {
    // 1. Validate message format and permissions
    this.validateMessage(message);
    
    // 2. Check for conflicts with current execution
    await this.checkForConflicts(message);
    
    // 3. Route to target droid or broadcast
    if (message.to_droid) {
      await this.sendToDroid(message);
    } else {
      await this.broadcast(message);
    }
    
    // 4. Log and track message
    this.logMessage(message);
  }
}
```

### Message Handling

#### Receiving Droid Responsibilities
```typescript
// Each droid implements message handling
class FrontendDeveloperDroid {
  async handleMessage(message: Message): Promise<void> {
    switch (message.type) {
      case "query":
        return this.handleQuery(message);
      case "coordination":
        return this.handleCoordination(message);
      case "discovery":
        return this.handleDiscovery(message);
    }
  }
  
  private async handleQuery(message: QueryMessage): Promise<void> {
    // Process query and respond
    const response = await this.processQuery(message.query);
    
    await this.orchestrator.sendMessage({
      type: "response",
      from_droid: "frontend-developer",
      to_droid: message.from_droid,
      correlation_id: message.metadata?.correlation_id,
      response: response
    });
  }
}
```

## Communication Patterns

### Pattern 1: Query-Response Pattern
```
Droid A: Query → Droid B
Droid B: Response → Droid A
Use: Information gathering, clarification requests
```

### Pattern 2: Dependency Notification Pattern
```
Droid A: "I'm blocked by X" → Orchestrator → Droid B
Orchestrator: "Droid A needs X to proceed" → Droid B
Droid B: "X is ready" → Orchestrator → Droid A
Use: Cross-phase dependencies, blocking issues
```

### Pattern 3: Discovery Broadcast Pattern
```
Droid A: "Found important discovery" → All relevant droids
Multiple droids: Respond with impact analysis
Use: Architecture discoveries, security findings, performance insights
```

### Pattern 4: Real-time Coordination Pattern
```
Droid A: "Making change X" → Droid B
Droid B: "Change X affects me, suggest Y" → Droid A
Droid A: "Implementing suggestion Y" → Droid B
Use: Parallel implementation, API contract alignment
```

## Safety and Conflict Management

### Message Validation
```typescript
interface MessageValidation {
  allowed_senders: string[];
  allowed_receivers: string[];
  content_filters: string[];
  urgency_limits: {
    [droid_name: string]: number; // max messages per minute
  };
}

class MessageValidator {
  validate(message: Message): ValidationResult {
    // Check sender permissions
    if (!this.allowedSenders.includes(message.from_droid)) {
      return { valid: false, reason: "Unauthorized sender" };
    }
    
    // Check receiver permissions
    if (message.to_droid && !this.allowedReceivers.includes(message.to_droid)) {
      return { valid: false, reason: "Unauthorized receiver" };
    }
    
    // Check content for security issues
    if (this.containsSensitiveData(message.content)) {
      return { valid: false, reason: "Sensitive data detected" };
    }
    
    // Check rate limits
    if (this.exceedsRateLimit(message.from_droid)) {
      return { valid: false, reason: "Rate limit exceeded" };
    }
    
    return { valid: true };
  }
}
```

### Conflict Detection
```typescript
class ConflictDetector {
  detectCommunicationConflict(message: Message): Conflict[] {
    const conflicts = [];
    
    // Check if message conflicts with current execution plan
    if (this.conflictsWithPlan(message)) {
      conflicts.push({
        type: "plan_conflict",
        description: "Message conflicts with current execution plan",
        resolution: "Pause plan or modify message"
      });
    }
    
    // Check if message creates circular dependencies
    if (this.createsCircularDependency(message)) {
      conflicts.push({
        type: "circular_dependency",
        description: "Message would create circular dependency",
        resolution: "Break cycle or reject message"
      });
    }
    
    return conflicts;
  }
}
```

## Performance Considerations

### Message Queue System
```typescript
class MessageQueue {
  private queue: Message[] = [];
  private processing = false;
  
  async enqueue(message: Message): Promise<void> {
    this.queue.push(message);
    
    if (!this.processing) {
      this.processQueue();
    }
  }
  
  private async processQueue(): Promise<void> {
    this.processing = true;
    
    while (this.queue.length > 0) {
      const message = this.queue.shift();
      
      try {
        await this.processMessage(message);
      } catch (error) {
        this.handleError(message, error);
      }
    }
    
    this.processing = false;
  }
}
```

### Communication Analytics
```typescript
interface CommunicationMetrics {
  total_messages: number;
  messages_by_type: Record<string, number>;
  messages_by_droid: Record<string, number>;
  average_response_time: number;
  conflict_rate: number;
  success_rate: number;
}

class CommunicationAnalytics {
  trackMessage(message: Message): void {
    this.metrics.total_messages++;
    this.metrics.messages_by_type[message.type]++;
    this.metrics.messages_by_droid[message.from_droid]++;
  }
  
  generateReport(): CommunicationReport {
    return {
      summary: this.metrics,
      insights: this.generateInsights(),
      recommendations: this.generateRecommendations()
    };
  }
}
```

## Integration with Existing Orchestrator

### Enhanced Task Tool
```typescript
// Enhanced Task tool with communication capabilities
interface TaskWithCommunication {
  subagent_type: string;
  description: string;
  prompt: string;
  communication_enabled?: boolean;
  allow_direct_messages?: boolean;
  communication_channels?: string[];
}

// Usage
Task({
  subagent_type: "frontend-developer",
  description: "Build user profile UI",
  prompt: "...",
  communication_enabled: true,
  allow_direct_messages: ["backend-architect", "security-auditor"],
  communication_channels: ["query", "discovery", "coordination"]
});
```

### Phase Enhancement
```typescript
interface EnhancedPhase {
  id: string;
  name: string;
  droids: string[];
  parallel: boolean;
  communication_enabled: boolean;
  communication_rules: {
    allow_inter_droid: boolean;
    allow_broadcast: boolean;
    message_types: string[];
  };
}
```

## Usage Examples

### Example 1: API Design Collaboration
```
Phase: Implementation (parallel)
Droids: [backend-typescript-architect, frontend-developer]
Communication: Enabled

Timeline:
T0: Both droids start
T5: Frontend developer needs clarification
T5: frontend-developer → backend-architect: "User profile API - what fields available?"
T7: backend-architect → frontend-developer: "id, name, email, bio, avatar_url"
T10: Frontend developer continues with proper data structure
Result: No waiting, seamless collaboration
```

### Example 2: Security Issue Discovery
```
Phase: Testing
Droid: test-automator
Discovery: SQL injection vulnerability in auth API

Communication Flow:
test-automator → security-auditor: "Found SQL injection in /api/auth/login"
security-auditor → backend-typescript-architect: "URGENT: Fix SQL injection immediately"
backend-typescript-architect → security-auditor: "Fixed with parameterized queries"
security-auditor → test-automator: "Please re-test auth endpoint"
Result: Real-time security fix without phase delay
```

### Example 3: Performance Optimization
```
Phase: Implementation (parallel)
Discovery: Performance engineer notices slow database query

Communication Flow:
performance-engineer → database-admin: "Query on users table taking 3s"
database-admin → performance-engineer: "Adding index on email column"
performance-engineer → backend-typescript-architect: "Expect faster queries in 2 min"
backend-typescript-architect → performance-engineer: "Thanks, updated API"
Result: Immediate performance optimization
```

## Configuration

### Enable Communication in Orchestrator Config
```json
{
  "communication": {
    "enabled": true,
    "default_channels": ["query", "response", "coordination"],
    "max_messages_per_phase": 50,
    "timeout_minutes": 15,
    "conflict_detection": true,
    "analytics_tracking": true
  },
  
  "droid_permissions": {
    "frontend-developer": {
      "can_send_to": ["backend-architect", "security-auditor", "test-automator"],
      "can_broadcast": false,
      "max_urgency": "high"
    },
    "security-auditor": {
      "can_send_to": ["*"],
      "can_broadcast": true,
      "max_urgency": "critical"
    }
  }
}
```

---

This communication protocol transforms the orchestrator from a sequential coordinator into a real-time collaborative development environment! 🤝
