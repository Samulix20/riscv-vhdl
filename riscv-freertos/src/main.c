/* FreeRTOS kernel includes. */
#include <FreeRTOS.h>
#include <task.h>
#include <queue.h>

#include <vhdl_print.h>

// FreeRTOS hook definitions
void vApplicationMallocFailedHook( void );
void vApplicationIdleHook( void );
void vApplicationStackOverflowHook( TaskHandle_t pxTask, char *pcTaskName );
void vApplicationTickHook( void );

// Queue lenght
#define mainQUEUE_LENGTH					( 1 )
static QueueHandle_t xQueue = NULL;

static void sendTask ( void *p ) {

	unsigned int send_val = 1;

	while(1) {
		print_str("Sending "); print_uint(send_val, 10); print_str("!\n");
		xQueueSend( xQueue, &send_val, 0 );
		send_val++;
		vTaskDelay( 100 );
	}

}

static void receiveTask ( void *p ) {

	unsigned int receive_val = 0;
	unsigned int expected_val = 1;
	
	while(1) {
		xQueueReceive( xQueue, &receive_val, portMAX_DELAY );
		print_str("Received "); print_uint(receive_val, 10); print_str("!\n");
		if (receive_val == expected_val) {
			print_str("Good val!\n");
			receive_val = 0;
			expected_val++;
		} else {
			print_str("Wrong val!\n");
			print_str("Expected: "); print_uint(receive_val, 10); 
			print_str(" got "); print_uint(expected_val, 10); print_str("\n");
			while(1);
		}
	}
}

int main( void ) 
{
    print_str("Hello FreeRTOS!\n");

	xQueue = xQueueCreate( mainQUEUE_LENGTH, sizeof( uint32_t ) );
	if (xQueue == NULL) {
		print_str("Queue error!\n");
		while(1);
	} 

	print_str("Queue created!\n");
	xTaskCreate(sendTask, "st", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, NULL);
	xTaskCreate(receiveTask, "rt", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2, NULL);
	
	vTaskStartScheduler();

	// Scheduler should never return
	print_str("Sched fail!\n");
    while(1);
}

/*-----------------------------------------------------------*/

void vApplicationMallocFailedHook( void )
{
	/* vApplicationMallocFailedHook() will only be called if
	configUSE_MALLOC_FAILED_HOOK is set to 1 in FreeRTOSConfig.h.  It is a hook
	function that will get called if a call to pvPortMalloc() fails.
	pvPortMalloc() is called internally by the kernel whenever a task, queue,
	timer or semaphore is created.  It is also called by various parts of the
	demo application.  If heap_1.c or heap_2.c are used, then the size of the
	heap available to pvPortMalloc() is defined by configTOTAL_HEAP_SIZE in
	FreeRTOSConfig.h, and the xPortGetFreeHeapSize() API function can be used
	to query the size of free heap space that remains (although it does not
	provide information on how the remaining heap might be fragmented). */
	taskDISABLE_INTERRUPTS();
    print_str("vApplicationMallocFailedHook\n");
	while(1);
}
/*-----------------------------------------------------------*/

void vApplicationIdleHook( void )
{
	/* vApplicationIdleHook() will only be called if configUSE_IDLE_HOOK is set
	to 1 in FreeRTOSConfig.h.  It will be called on each iteration of the idle
	task.  It is essential that code added to this hook function never attempts
	to block in any way (for example, call xQueueReceive() with a block time
	specified, or call vTaskDelay()).  If the application makes use of the
	vTaskDelete() API function (as this demo application does) then it is also
	important that vApplicationIdleHook() is permitted to return to its calling
	function, because it is the responsibility of the idle task to clean up
	memory allocated by the kernel to any task that has since been deleted. */
	print_str("Idle\n");
}
/*-----------------------------------------------------------*/

void vApplicationStackOverflowHook( TaskHandle_t pxTask, char *pcTaskName )
{
	( void ) pcTaskName;
	( void ) pxTask;

	/* Run time stack overflow checking is performed if
	configCHECK_FOR_STACK_OVERFLOW is defined to 1 or 2.  This hook
	function is called if a stack overflow is detected. */
	taskDISABLE_INTERRUPTS();
    print_str("vApplicationStackOverflowHook\n");
	while(1);
}
/*-----------------------------------------------------------*/

void vApplicationTickHook( void )
{

}
/*-----------------------------------------------------------*/

void vAssertCalled( void )
{
    volatile uint32_t ulSetTo1ToExitFunction = 0;

	taskDISABLE_INTERRUPTS();
    print_str("vAssertCalled\n");
	while( ulSetTo1ToExitFunction != 1 )
	{
		__asm volatile( "NOP" );
	}
}
